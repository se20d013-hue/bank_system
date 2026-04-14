import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  static SupabaseClient get _client => Supabase.instance.client;
  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => _client.auth.currentUser?.id;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://msxuvfrttvcjrzwabnyk.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zeHV2ZnJ0dHZjanJ6d2FibnlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMTk1NDIsImV4cCI6MjA4ODY5NTU0Mn0.B7T1uNvpfCfG-dpQusBYwqBdNmusKzY7_YOBWZZOjlo',
    );
  }

  // ── Нэвтрэх (и-мэйл + нууц үгээр — RLS асуудалгүй) ──
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Нэвтрэх (утасны дугаараар → profiles-с жинхэнэ email хайж нэвтрэх) ──
  static Future<AuthResponse> signIn({
    required String phone,
    required String password,
  }) async {
    final result = await _client
        .from('profiles')
        .select('email')
        .eq('phone', phone)
        .maybeSingle();

    if (result == null || result['email'] == null) {
      throw Exception('Бүртгэлтэй утасны дугаар олдсонгүй');
    }

    final email = result['email'] as String;
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Бүртгүүлэх ──
  static Future<AuthResponse> signUp({
    required String phone,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String registerNumber,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'phone': phone,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'register_number': registerNumber,
      },
    );
    if (response.user != null) {
      await _client.from('profiles').insert({
        'id': response.user!.id,
        'phone': phone,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'register_number': registerNumber,
      });
    }
    return response;
  }

  static Future<void> signOut() async => await _client.auth.signOut();

  static Future<ProfileModel?> getProfile() async {
    if (currentUserId == null) return null;
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', currentUserId!)
        .single();
    return ProfileModel.fromJson(data);
  }

  static Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return;
    await _client.from('profiles').update({
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', currentUserId!);
  }

  static Future<List<LoanProductModel>> getLoanProducts() async {
    final data = await _client
        .from('loan_products')
        .select()
        .eq('is_active', true)
        .order('loan_type');
    return data
        .map<LoanProductModel>((json) => LoanProductModel.fromJson(json))
        .toList();
  }

  static Future<LoanApplicationModel> submitLoanApplication({
    required String productId,
    required double requestedAmount,
    required int requestedTermMonths,
    String? loanPurpose,
    List<Map<String, String>>? documents,
  }) async {
    final appNumber = await _client.rpc('generate_application_number');
    final data = await _client
        .from('loan_applications')
        .insert({
          'application_number': appNumber,
          'user_id': currentUserId!,
          'product_id': productId,
          'requested_amount': requestedAmount,
          'requested_term_months': requestedTermMonths,
          'loan_purpose': loanPurpose,
          'documents': documents ?? [],
        })
        .select('*, loan_products(name_mn)')
        .single();
    return LoanApplicationModel.fromJson(data);
  }

  static Future<List<LoanApplicationModel>> getMyApplications() async {
    final data = await _client
        .from('loan_applications')
        .select('*, loan_products(name_mn)')
        .eq('user_id', currentUserId!)
        .order('created_at', ascending: false);
    return data
        .map<LoanApplicationModel>(
          (json) => LoanApplicationModel.fromJson(json),
        )
        .toList();
  }

  static Future<List<LoanModel>> getMyLoans() async {
    final data = await _client
        .from('loans')
        .select('*, loan_products(name_mn)')
        .eq('user_id', currentUserId!)
        .order('created_at', ascending: false);
    return data.map<LoanModel>((json) => LoanModel.fromJson(json)).toList();
  }

  static Future<LoanModel?> getLoan(String loanId) async {
    final data = await _client
        .from('loans')
        .select('*, loan_products(name_mn)')
        .eq('id', loanId)
        .single();
    return LoanModel.fromJson(data);
  }

  static Future<List<ScheduleModel>> getLoanSchedule(String loanId) async {
    final data = await _client
        .from('loan_schedules')
        .select()
        .eq('loan_id', loanId)
        .order('installment_number');
    return data
        .map<ScheduleModel>((json) => ScheduleModel.fromJson(json))
        .toList();
  }

  static Future<void> makePayment({
    required String loanId,
    required double amount,
    required String paymentMethod,
    String? scheduleId,
  }) async {
    final txNumber = 'TXN${DateTime.now().millisecondsSinceEpoch}';
    await _client.from('payment_transactions').insert({
      'transaction_number': txNumber,
      'loan_id': loanId,
      'user_id': currentUserId!,
      'schedule_id': scheduleId,
      'payment_amount': amount,
      'payment_method': paymentMethod,
      'status': 'completed',
    });
  }

  static Future<List<Map<String, dynamic>>> getPaymentHistory(
    String loanId,
  ) async {
    return await _client
        .from('payment_transactions')
        .select()
        .eq('loan_id', loanId)
        .order('paid_at', ascending: false);
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    if (currentUserId == null) return [];
    return await _client
        .from('notifications')
        .select()
        .eq('user_id', currentUserId!)
        .order('created_at', ascending: false)
        .limit(50);
  }

  static Future<void> markNotificationRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }

  static double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  static double calculateMonthlyPayment(
    double principal,
    double monthlyRate,
    int months,
  ) {
    if (months == 0) return 0;
    if (monthlyRate == 0) return principal / months;
    final rate = monthlyRate / 100;
    final pow = _pow(1 + rate, months);
    return principal * (rate * pow) / (pow - 1);
  }

  static List<Map<String, double>> calculateSchedule(
    double principal,
    double monthlyRate,
    int months,
  ) {
    final rate = monthlyRate / 100;
    final monthlyPayment = calculateMonthlyPayment(
      principal,
      monthlyRate,
      months,
    );
    double remaining = principal;
    List<Map<String, double>> schedule = [];
    for (int i = 1; i <= months; i++) {
      final interest = remaining * rate;
      final principalPay = monthlyPayment - interest;
      schedule.add({
        'month': i.toDouble(),
        'principal': principalPay,
        'interest': interest,
        'total': monthlyPayment,
        'remaining': remaining - principalPay,
      });
      remaining -= principalPay;
    }
    return schedule;
  }
}
