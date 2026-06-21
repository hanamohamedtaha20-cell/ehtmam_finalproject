#!/usr/bin/env python3
"""
Apply easy_localization .tr() calls across all Flutter UI files.
Replaces hardcoded Text('...'), hintText, labelText, tooltip, etc.
Updates en.json and ar.json.
"""
import re, json, sys, io
from pathlib import Path

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

ROOT = Path('.')

# ──────────────────────────────────────────────────────────────────────────────
# TRANSLATION DICTIONARY   english_string -> (key, arabic_string)
# ──────────────────────────────────────────────────────────────────────────────
TRANSLATIONS = {
    # Buttons / Actions
    'Refresh':          ('refresh', 'تحديث'),
    'Retry':            ('retry', 'إعادة المحاولة'),
    'Cancel':           ('cancel', 'إلغاء'),
    'Logout':           ('logout', 'تسجيل الخروج'),
    'Reject':           ('reject', 'رفض'),
    'Close':            ('close', 'إغلاق'),
    'Approve':          ('approve', 'موافقة'),
    'Accept':           ('accept', 'قبول'),
    'Delete':           ('delete', 'حذف'),
    'Edit':             ('edit', 'تعديل'),
    'Block':            ('block', 'حظر'),
    'Back':             ('back', 'رجوع'),
    'Add':              ('add', 'إضافة'),
    'Confirm':          ('confirm', 'تأكيد'),
    'Done':             ('done', 'تم'),
    'Open':             ('open', 'فتح'),
    'Decline':          ('decline', 'رفض'),
    'Rebook':           ('rebook', 'حجز مجدد'),
    'Purchased':        ('purchased', 'تم الشراء'),
    'Log In':           ('log_in', 'تسجيل الدخول'),
    'Try Again':        ('try_again', 'حاول مرة أخرى'),
    'View Details':     ('view_details', 'عرض التفاصيل'),
    'View Details →':   ('view_details_arrow', 'عرض التفاصيل ←'),
    'View Tasks':       ('view_tasks', 'عرض المهام'),
    'View Bundles':     ('view_bundles', 'عرض الباقات'),
    'View Documents':   ('view_documents', 'عرض المستندات'),
    'View Transactions':('view_transactions', 'عرض المعاملات'),
    'Send for Approval':('send_for_approval', 'إرسال للموافقة'),
    'Submit Review':    ('submit_review', 'إرسال المراجعة'),
    'Submit Request':   ('submit_request', 'إرسال الطلب'),
    'Submit Documents': ('submit_documents', 'تقديم المستندات'),
    'Submit Complaint': ('submit_complaint', 'تقديم شكوى'),
    'Create Request':   ('create_request', 'إنشاء طلب'),
    'Purchase Bundle':  ('purchase_bundle', 'شراء الباقة'),
    'Add Funds':        ('add_funds', 'إضافة رصيد'),
    'Add Task':         ('add_task', 'إضافة مهمة'),
    'Add New Task':     ('add_new_task', 'إضافة مهمة جديدة'),
    'Add Extra Task':   ('add_extra_task', 'إضافة مهمة إضافية'),
    'Copy Reference Number': ('copy_reference', 'نسخ الرقم المرجعي'),
    'Upload Documents': ('upload_documents', 'رفع المستندات'),
    'Upload Documents Again': ('upload_docs_again', 'رفع المستندات مجدداً'),
    'Upload Profile Picture': ('upload_profile_pic', 'رفع صورة الملف الشخصي'),
    'Upload National ID':('upload_national_id', 'رفع الرقم القومي'),
    'Upload Certificate':('upload_certificate', 'رفع الشهادة'),
    'Back to Home':     ('back_to_home', 'العودة للرئيسية'),
    'Back to Login':    ('back_to_login', 'العودة لتسجيل الدخول'),
    'Rate Client':      ('rate_client', 'تقييم العميل'),
    'Rate the service': ('rate_the_service', 'قيّم الخدمة'),
    'Cancel Booking':   ('cancel_booking', 'إلغاء الحجز'),
    'Contact':          ('contact', 'التواصل'),
    'Contact Caregiver':('contact_caregiver', 'التواصل مع مقدم الرعاية'),
    'Check Out':        ('check_out', 'تسجيل الخروج من العمل'),
    'Check In to Start Work': ('check_in_to_start', 'تسجيل الدخول لبدء العمل'),
    'Reset Password':   ('reset_password', 'إعادة تعيين كلمة المرور'),
    'Set New Password': ('set_new_password', 'تعيين كلمة مرور جديدة'),
    'Change Password':  ('change_password', 'تغيير كلمة المرور'),
    'Update your password': ('update_your_password', 'تحديث كلمة المرور'),
    'Update your documents and resubmit for approval.': ('update_docs_resubmit', 'يرجى تحديث مستنداتك وإعادة تقديمها للموافقة.'),
    'Create New Bundle':('create_new_bundle', 'إنشاء باقة جديدة'),
    'Edit Bundle':      ('edit_bundle', 'تعديل الباقة'),

    # Navigation / Screen titles
    'Profile':          ('profile', 'الملف الشخصي'),
    'Dashboard':        ('dashboard', 'لوحة التحكم'),
    'Settings':         ('settings', 'الإعدادات'),
    'Notifications':    ('notifications', 'الإشعارات'),
    'Account Settings': ('account_settings', 'إعدادات الحساب'),
    'My Profile':       ('my_profile', 'ملفي الشخصي'),
    'My Tasks':         ('my_tasks', 'مهامي'),
    'My Ratings':       ('my_ratings', 'تقييماتي'),
    'My Bookings':      ('my_bookings', 'حجوزاتي'),
    'Track Caregiver':  ('track_caregiver', 'تتبع مقدم الرعاية'),
    'Share Location':   ('share_location', 'مشاركة الموقع'),
    'Admin Dashboard':  ('admin_dashboard', 'لوحة تحكم المشرف'),
    'Care Requests':    ('care_requests', 'طلبات الرعاية'),
    'Manage Complaints':('manage_complaints', 'إدارة الشكاوى'),
    'Pending Approvals':('pending_approvals', 'الموافقات المعلقة'),
    'Transaction Details': ('transaction_details', 'تفاصيل المعاملة'),
    'Offer Details':    ('offer_details', 'تفاصيل العرض'),
    'Complaint Details':('complaint_details', 'تفاصيل الشكوى'),
    'Login Required':   ('login_required', 'يجب تسجيل الدخول'),

    # Fields / Labels
    'Full Name':        ('full_name', 'الاسم الكامل'),
    'Email Address':    ('email_address', 'البريد الإلكتروني'),
    'Email':            ('email', 'البريد الإلكتروني'),
    'Phone Number':     ('phone_number', 'رقم الهاتف'),
    'Address':          ('address', 'العنوان'),
    'Governorate':      ('governorate', 'المحافظة'),
    'Password':         ('password', 'كلمة المرور'),
    'New password':     ('new_password', 'كلمة المرور الجديدة'),
    'Confirm new password': ('confirm_new_password', 'تأكيد كلمة المرور الجديدة'),
    'Location':         ('location', 'الموقع'),
    'Description':      ('description', 'الوصف'),
    'Date':             ('date', 'التاريخ'),
    'Time':             ('time', 'الوقت'),
    'Duration':         ('duration', 'المدة'),
    'Title':            ('title_label', 'العنوان'),
    'Notes':            ('notes', 'ملاحظات'),
    'Notes (Optional)': ('notes_optional', 'ملاحظات (اختياري)'),
    'Details':          ('details', 'التفاصيل'),
    'Message':          ('message', 'الرسالة'),
    'Price (EGP)':      ('price_egp', 'السعر (جنيه)'),
    'Street':           ('street', 'الشارع'),
    'Building':         ('building', 'المبنى'),
    'Service Type':     ('service_type', 'نوع الخدمة'),
    'Service Types':    ('service_types', 'أنواع الخدمات'),
    'Service Area':     ('service_area', 'منطقة الخدمة'),
    'Experience':       ('experience', 'الخبرة'),
    'Specialization':   ('specialization', 'التخصص'),
    'Certificate':      ('certificate', 'الشهادة'),
    'Certificates':     ('certificates', 'الشهادات'),
    'Profile Picture':  ('profile_picture', 'صورة الملف الشخصي'),
    'National ID':      ('national_id', 'الرقم القومي'),
    'Reference Number': ('reference_number', 'الرقم المرجعي'),
    'Transaction ID':   ('transaction_id', 'معرف المعاملة'),
    'Task Description': ('task_description', 'وصف المهمة'),
    'Task Progress':    ('task_progress', 'تقدم المهمة'),
    'Tasks':            ('tasks', 'المهام'),
    'Progress':         ('progress', 'التقدم'),
    'Contact Information': ('contact_information', 'معلومات التواصل'),
    'Response Time':    ('response_time', 'وقت الاستجابة'),
    'Proposed Price':   ('proposed_price', 'السعر المقترح'),
    'Provider Notes':   ('provider_notes', 'ملاحظات مقدم الخدمة'),
    'Provider Notes:':  ('provider_notes_label', 'ملاحظات مقدم الخدمة:'),
    'Provider Proposal':('provider_proposal', 'عرض مقدم الخدمة'),
    'Payment Breakdown':('payment_breakdown', 'تفاصيل الدفع'),
    'Cost Breakdown':   ('cost_breakdown', 'تفاصيل التكلفة'),
    'Location Details': ('location_details', 'تفاصيل الموقع'),
    'Privacy Notice':   ('privacy_notice', 'إشعار الخصوصية'),
    'Live Location Tracking': ('live_tracking', 'التتبع المباشر'),
    'Your Location':    ('your_location', 'موقعك'),
    'Your Current Location': ('your_current_location', 'موقعك الحالي'),
    "Client's Location":('clients_location', 'موقع العميل'),
    "Caregiver's Current Location": ('caregiver_current_loc', 'الموقع الحالي لمقدم الرعاية'),
    'Documents Required':('documents_required', 'المستندات المطلوبة'),
    'Mental Health Document': ('mental_health_doc', 'وثيقة الصحة النفسية'),

    # Stats / Metrics
    'Total Requests':   ('total_requests', 'إجمالي الطلبات'),
    'Total Earnings':   ('total_earnings', 'إجمالي الأرباح'),
    'Total Users':      ('total_users', 'إجمالي المستخدمين'),
    'Total Provider':   ('total_provider', 'إجمالي مقدمي الخدمة'),
    'Total Added':      ('total_added', 'إجمالي المضاف'),
    'Total Spent':      ('total_spent', 'إجمالي المنفق'),
    'Available Balance':('available_balance', 'الرصيد المتاح'),
    'Payments Received':('payments_received', 'المدفوعات المستلمة'),
    'Earnings':         ('earnings', 'الأرباح'),
    'Jobs':             ('jobs', 'الوظائف'),
    'Avg Job':          ('avg_job', 'متوسط الوظيفة'),
    'Hours':            ('hours', 'ساعات'),
    'Remaining Sessions':('remaining_sessions', 'الجلسات المتبقية'),
    'Completed Services':('completed_services', 'الخدمات المكتملة'),

    # Status labels
    'Pending':          ('pending', 'قيد الانتظار'),
    'Accepted':         ('accepted', 'مقبول'),
    'Completed':        ('completed', 'مكتمل'),
    'Active':           ('active', 'نشط'),
    'All':              ('all', 'الكل'),
    'Checked In':       ('checked_in', 'تم الدخول'),
    'Location tracked': ('location_tracked', 'تتبع الموقع'),
    'Verified':         ('verified', 'موثق'),
    'Certified':        ('certified', 'معتمد'),
    'Best Value':       ('best_value', 'أفضل قيمة'),
    'Arriving Soon':    ('arriving_soon', 'قادم قريباً'),
    'Offer Accepted':   ('offer_accepted', 'تم قبول العرض'),
    'Offer Accepted':   ('offer_accepted', 'تم قبول العرض'),
    'Paid by Bundle':   ('paid_by_bundle', 'مدفوع بالباقة'),

    # Sections
    'About Provider':   ('about_provider', 'عن مقدم الخدمة'),
    'Services Includes':('services_includes', 'الخدمات المشمولة'),
    'Quick Actions':    ('quick_actions', 'إجراءات سريعة'),
    'Transaction History': ('transaction_history', 'سجل المعاملات'),
    'Recent Transactions': ('recent_transactions', 'المعاملات الأخيرة'),
    'Overall Rating':   ('overall_rating', 'التقييم الإجمالي'),
    'Detailed Ratings': ('detailed_ratings', 'التقييمات التفصيلية'),
    'Communication':    ('communication', 'التواصل'),
    'Rate Your Experience': ('rate_your_experience', 'قيّم تجربتك'),
    'Received Offers':  ('received_offers', 'العروض المستلمة'),
    'New Care Requests':('new_care_requests', 'طلبات رعاية جديدة'),
    'Active Bookings':  ('active_bookings', 'الحجوزات النشطة'),
    'Availability Status': ('availability_status', 'حالة التوفر'),
    'Select Payment Method': ('select_payment_method', 'اختر طريقة الدفع'),
    'Quick Amounts':    ('quick_amounts', 'مبالغ سريعة'),
    'Custom Amount':    ('custom_amount', 'مبلغ مخصص'),
    'Select a category':('select_category', 'اختر فئة'),
    'Push Notifications':('push_notifications', 'الإشعارات الفورية'),
    'New request alerts':('new_request_alerts', 'تنبيهات الطلبات الجديدة'),

    # Roles / Personas
    'User':             ('user_role', 'مستخدم'),
    'Care giver':       ('care_giver', 'مقدم رعاية'),
    'Users':            ('users', 'المستخدمون'),
    'Providers':        ('providers', 'مقدمو الرعاية'),
    'Client':           ('client', 'العميل'),
    'Certified Provider':('certified_provider', 'مقدم معتمد'),
    'Super Admin':      ('super_admin', 'مشرف عام'),
    'Care providers have responded': ('providers_responded', 'مقدمو الرعاية استجابوا'),
    'years experience': ('years_experience', 'سنوات خبرة'),

    # Empty states
    'No tasks found':   ('no_tasks_found', 'لا توجد مهام'),
    'No tasks available':('no_tasks_available', 'لا توجد مهام متاحة'),
    'No requests found':('no_requests_found', 'لا توجد طلبات'),
    'No offer details available': ('no_offer_details', 'لا توجد تفاصيل للعرض'),
    'No offers received yet': ('no_offers_yet', 'لم تصل أي عروض بعد'),
    'No bundles available':('no_bundles', 'لا توجد باقات متاحة'),
    'No bundles found': ('no_bundles_found', 'لا توجد باقات'),
    'No services available':('no_services', 'لا توجد خدمات متاحة'),
    'No transactions yet':('no_transactions', 'لا توجد معاملات بعد'),
    'No transactions found':('no_transactions_found', 'لا توجد معاملات'),
    'No bookings found':('no_bookings_found', 'لا توجد حجوزات'),
    'No notifications yet':('no_notifications', 'لا توجد إشعارات بعد'),
    'No users found':   ('no_users_found', 'لا يوجد مستخدمون'),
    'No providers found':('no_providers_found', 'لا يوجد مقدمو خدمة'),
    'No complaints found.':('no_complaints', 'لا توجد شكاوى.'),
    'No ratings yet':   ('no_ratings_yet', 'لا توجد تقييمات بعد'),
    'No active bookings yet.': ('no_active_bookings', 'لا توجد حجوزات نشطة بعد.'),
    'No features added yet. Type a feature and press Add.': ('no_features_added', 'لم تُضَف أي مميزات. اكتب ميزة واضغط إضافة.'),

    # Errors / States
    'Error':            ('error', 'خطأ'),
    'Error loading data':('error_loading_data', 'خطأ في تحميل البيانات'),
    'Error loading provider data': ('error_loading_provider', 'خطأ في تحميل بيانات مقدم الخدمة'),
    'Error loading reviews': ('error_loading_reviews', 'خطأ في تحميل المراجعات'),
    'Could not load task progress': ('could_not_load_tasks', 'تعذر تحميل تقدم المهمة'),
    'Could not load payment data': ('could_not_load_payment', 'تعذر تحميل بيانات الدفع'),
    'Could not load notifications': ('could_not_load_notif', 'تعذر تحميل الإشعارات'),
    'Session Expired':  ('session_expired', 'انتهت الجلسة'),

    # Success messages
    'Offer sent':           ('offer_sent', 'تم إرسال العرض'),
    'Review submitted successfully!': ('review_submitted', 'تم إرسال المراجعة بنجاح!'),
    'Request Created Successfully': ('request_created', 'تم إنشاء الطلب بنجاح'),
    'Checked in successfully':('checked_in_success', 'تم تسجيل الدخول بنجاح'),
    'Bundle purchased successfully':('bundle_purchased', 'تم شراء الباقة بنجاح'),
    'Complaint submitted successfully':('complaint_submitted', 'تم تقديم الشكوى بنجاح'),
    'Reference number copied successfully.':('reference_copied', 'تم نسخ الرقم المرجعي بنجاح.'),
    'PDF link copied to clipboard':('pdf_copied', 'تم نسخ رابط PDF إلى الحافظة'),
    'Caregiver approved successfully':('caregiver_approved', 'تمت الموافقة على مقدم الرعاية بنجاح'),
    'Caregiver application rejected successfully.':('caregiver_rejected', 'تم رفض طلب مقدم الرعاية بنجاح.'),
    'Withdrawal Request Created':('withdrawal_created', 'تم إنشاء طلب السحب'),
    'Your withdrawal request has been successfully created.':('withdrawal_success', 'تم إنشاء طلب السحب بنجاح.'),

    # Failure messages
    'Failed to approve. Please try again.': ('failed_to_approve', 'فشلت الموافقة. يرجى المحاولة مجدداً.'),
    'Failed to reject. Please try again.': ('failed_to_reject', 'فشل الرفض. يرجى المحاولة مجدداً.'),
    'Failed to submit documents. Please try again.': ('failed_submit_docs', 'فشل تقديم المستندات. يرجى المحاولة مجدداً.'),

    # Validation messages
    'Please enter a valid price': ('enter_valid_price', 'يرجى إدخال سعر صحيح'),
    'Please enter a valid amount': ('enter_valid_amount', 'يرجى إدخال مبلغ صحيح'),
    'Please fill in both fields.': ('fill_both_fields', 'يرجى ملء كلا الحقلين.'),
    'Please enter your email address.': ('enter_email_address', 'يرجى إدخال عنوان البريد الإلكتروني.'),
    'Please enter a valid email address.': ('enter_valid_email', 'يرجى إدخال عنوان بريد إلكتروني صحيح.'),
    'Please enter email and password': ('enter_email_password', 'يرجى إدخال البريد الإلكتروني وكلمة المرور'),
    'Invalid email or password': ('invalid_credentials', 'البريد الإلكتروني أو كلمة المرور غير صحيحة'),
    'Please upload at least one document.': ('upload_at_least_one_doc', 'يرجى رفع مستند واحد على الأقل.'),
    'Please select a request to add tasks': ('select_request_first', 'يرجى اختيار طلب لإضافة مهام'),
    'Budget is required': ('budget_required', 'الميزانية مطلوبة'),
    'Please add at least one task': ('add_at_least_one_task', 'يرجى إضافة مهمة واحدة على الأقل'),
    'Service type is required. Please go back and select a service.': ('service_type_required', 'نوع الخدمة مطلوب. يرجى الرجوع واختيار خدمة.'),
    'Please login to view your requests.': ('login_to_view_requests', 'يرجى تسجيل الدخول لعرض طلباتك.'),
    'Please login to view your bookings.': ('login_to_view_bookings', 'يرجى تسجيل الدخول لعرض حجوزاتك.'),
    'Please login to view your profile.': ('login_to_view_profile', 'يرجى تسجيل الدخول لعرض ملفك الشخصي.'),
    'Please log in again to view your profile.': ('login_again_for_profile', 'يرجى تسجيل الدخول مجدداً لعرض ملفك الشخصي.'),
    'Minimum 20 characters': ('min_20_chars', 'الحد الأدنى 20 حرفًا'),
    'Please check your connection and try again.': ('check_connection_retry', 'يرجى التحقق من اتصالك والمحاولة مجدداً.'),
    'You must check in before completing tasks': ('must_check_in_first', 'يجب تسجيل الدخول قبل إتمام المهام'),
    'You must share your location first before viewing tasks.': ('share_location_first', 'يجب مشاركة موقعك أولاً قبل عرض المهام.'),
    'Booking not ready yet. Please wait and refresh.': ('booking_not_ready', 'الحجز غير جاهز بعد. يرجى الانتظار والتحديث.'),
    'Upload proof for all tasks before checking out': ('upload_proof_first', 'يرجى رفع إثبات لجميع المهام قبل تسجيل الخروج'),
    'Upload photo/video proof before marking as done': ('upload_proof_before_done', 'يرجى رفع صورة/فيديو إثبات قبل التمييز كمنجز'),
    'Waiting for client to approve this task.': ('waiting_client_approval', 'في انتظار موافقة العميل على هذه المهمة.'),
    'Client rejected this extra task.': ('client_rejected_task', 'رفض العميل هذه المهمة الإضافية.'),

    # Form hints / placeholders
    'Enter task description...': ('enter_task_desc', 'أدخل وصف المهمة...'),
    'your@email.com':   ('email_placeholder', 'بريدك@مثال.com'),
    'Enter your full name':('enter_full_name', 'أدخل اسمك الكامل'),
    'Enter your email': ('enter_your_email', 'أدخل بريدك الإلكتروني'),
    'Enter your street':('enter_street', 'أدخل شارعك'),
    'Enter your building number':('enter_building', 'أدخل رقم مبناك'),
    'Enter your phone number':('enter_phone', 'أدخل رقم هاتفك'),
    'Enter your password':('enter_password', 'أدخل كلمة المرور'),
    'Confirm your password':('confirm_password', 'تأكيد كلمة المرور'),
    'Select Care Field...':('select_care_field', 'اختر مجال الرعاية...'),
    'Select Specialization...':('select_specialization', 'اختر التخصص...'),
    'Select your Government':('select_government', 'اختر المحافظة'),
    'Select governorate':('select_governorate', 'اختر المحافظة'),
    'Describe what you need...':('describe_your_need', 'صف ما تحتاجه...'),
    'Enter your price...':('enter_price', 'أدخل سعرك...'),
    "Add specific tasks you'd like the caregiver to complete":('add_tasks_desc', 'أضف مهاماً محددة تريد من مقدم الرعاية إتمامها'),
    'Enter a task...':  ('enter_task', 'أدخل مهمة...'),
    'Enter your current password and\nchoose a new password':('enter_current_new_password', 'أدخل كلمة مرورك الحالية واختر كلمة مرور جديدة'),
    'Add any notes about your offer..': ('add_notes', 'أضف أي ملاحظات حول عرضك...'),
    'Search users...':  ('search_users', 'بحث عن المستخدمين...'),
    'Search Providers...':('search_providers', 'بحث عن مقدمي الخدمة...'),
    'Explain why you are blocking this user...':('explain_block_user', 'اشرح سبب حظر هذا المستخدم...'),
    'Explain why you are blocking this provider...':('explain_block_provider', 'اشرح سبب حظر هذا مقدم الخدمة...'),
    'Type message':     ('type_message', 'اكتب رسالة'),
    'Share your thoughts about the service...':('share_thoughts', 'شارك أفكارك حول الخدمة...'),
    'How was your experience with the client?':('how_was_client_exp', 'كيف كانت تجربتك مع العميل؟'),
    'Share your feedback about the client, The app...':('share_feedback', 'شارك تقييمك حول العميل والتطبيق...'),
    'Write a Review (optional)':('write_review_optional', 'اكتب مراجعة (اختياري)'),
    'e.g. PC Cleaning': ('eg_task_title', 'مثال: تنظيف الحاسوب'),
    'e.g. Clean personal computer area':('eg_task_desc', 'مثال: تنظيف منطقة الحاسوب الشخصي'),
    'e.g. 150':         ('eg_price', 'مثال: 150'),
    'e.g., Priority support':('eg_priority_support', 'مثال: دعم أولوي'),
    'Special Requirements':('special_requirements', 'متطلبات خاصة'),
    'Reason for Blocking *':('reason_for_blocking', 'سبب الحظر *'),

    # Descriptions / Long text
    'You are currently unavailable. Turn availability on to receive requests.':
        ('currently_unavailable', 'أنت غير متاح حالياً. قم بتشغيل التوفر لاستقبال الطلبات.'),
    'Your honest feedback helps improve our services':
        ('honest_feedback_helps', 'تقييمك الصادق يساعدنا على تحسين خدماتنا'),
    'Your feedback helps us improve our services':
        ('feedback_helps', 'تقييمك يساعدنا على تحسين خدماتنا'),
    'This action will permanently delete your account and cannot be undone.':
        ('delete_account_warning', 'هذا الإجراء سيحذف حسابك نهائياً ولا يمكن التراجع عنه.'),
    'Are you sure you want to permanently delete your account? This action cannot be undone.':
        ('confirm_delete_account', 'هل أنت متأكد من حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.'),
    'Please upload clear, correct documents for review.':
        ('upload_clear_docs', 'يرجى رفع مستندات واضحة وصحيحة للمراجعة.'),
    'This task will be sent to the client for approval.':
        ('task_sent_for_approval', 'ستُرسل هذه المهمة للعميل للموافقة عليها.'),
    'Caregiver is heading to your location':
        ('caregiver_heading', 'مقدم الرعاية في طريقه إلى موقعك'),
    'You need to login or create an account to create service requests':
        ('login_to_create_requests', 'يجب تسجيل الدخول أو إنشاء حساب لإنشاء طلبات الخدمة'),
    'As a guest, you can browse the app but cannot create requests':
        ('guest_browse_notice', 'كضيف، يمكنك تصفح التطبيق ولكن لا يمكنك إنشاء طلبات'),
    'Start sharing your location to let the client track your arrival':
        ('start_sharing_desc', 'ابدأ مشاركة موقعك ليتمكن العميل من تتبع وصولك'),
    'By submitting, you agree that the information provided is accurate.':
        ('submit_accuracy_agree', 'بالإرسال، فأنت توافق على دقة المعلومات المقدمة.'),
    'This reason will be stored for record keeping and may be shared with the user.':
        ('block_reason_note_user', 'سيُحفظ هذا السبب للسجلات وقد يُشارك مع المستخدم.'),
    'This reason will be stored for record keeping and may be shared with the provider.':
        ('block_reason_note_prov', 'سيُحفظ هذا السبب للسجلات وقد يُشارك مع مقدم الخدمة.'),
    'Location sharing started successfully. You can now view your tasks.':
        ('location_sharing_started', 'بدأت مشاركة الموقع بنجاح. يمكنك الآن عرض مهامك.'),
    'Your account is under review':
        ('account_under_review', 'حسابك قيد المراجعة'),
    "Please wait while our admin team\nreviews your documents. You will\nbe notified once approved":
        ('pending_review_desc', 'يرجى الانتظار بينما يراجع فريق الإدارة مستنداتك. ستُبلَّغ عند الموافقة.'),
    'Review and approve provider registrations':
        ('review_approve_providers', 'مراجعة والموافقة على تسجيلات مقدمي الخدمة'),
    "We're here to help":
        ('were_here_to_help', 'نحن هنا للمساعدة'),
    'Get up to 40% off with service packages':
        ('bundles_discount_desc', 'احصل على خصم يصل إلى 40% مع باقات الخدمة'),
    'Powered by Artificial Intelligence':
        ('powered_by_ai', 'مدعوم بالذكاء الاصطناعي'),
    'Trusted Care':     ('trusted_care', 'رعاية موثوقة'),
    'Save with Bundles':('save_with_bundles', 'وفّر مع الباقات'),
    'Registration Complete!':('registration_complete', 'اكتمل التسجيل!'),
    'Approval Status:': ('approval_status', 'حالة الموافقة:'),
    'Block User':       ('block_user', 'حظر المستخدم'),
    'Block Provider':   ('block_provider', 'حظر مقدم الرعاية'),
    'Delete Account':   ('delete_account', 'حذف الحساب'),
    'Delete Account?':  ('delete_account_q', 'هل تريد حذف الحساب؟'),
    'Permanently delete your account':('permanently_delete_account', 'حذف حسابك نهائياً'),
    'Documents Need Review':('documents_need_review', 'المستندات تحتاج مراجعة'),
    'Your documents contain incorrect or unclear information. Please review':
        ('docs_need_review_desc', 'مستنداتك تحتوي على معلومات غير صحيحة أو غير واضحة. يرجى المراجعة.'),
    'Select Your Role': ('select_your_role', 'اختر دورك'),
    'Trusted Care Services Platform':('trusted_care_platform', 'منصة خدمات الرعاية الموثوقة'),
    'Welcome back':     ('welcome_back', 'مرحباً بعودتك'),
    'Welcome back,':    ('welcome_back_comma', 'مرحباً بعودتك،'),
    'Forgot Password?': ('forgot_password', 'نسيت كلمة المرور؟'),
    'Continue as a Guest!':('continue_as_guest', 'متابعة كضيف!'),
    'Tap to rate':      ('tap_to_rate', 'اضغط للتقييم'),
    'Verified Providers':('verified_providers', 'مقدمون موثوقون'),
    'How Was Your Service Experience':('how_was_service', 'كيف كانت تجربتك مع الخدمة'),
    "Thank You for Your\nReview!":('thank_you_review', 'شكراً على مراجعتك!'),
    'Submit a Complaint':('submit_a_complaint', 'تقديم شكوى'),
    'Care Requests':    ('care_requests', 'طلبات الرعاية'),
    'Active Bookings':  ('active_bookings', 'الحجوزات النشطة'),
}

# ──────────────────────────────────────────────────────────────────────────────
# Helper: generate replacement
# ──────────────────────────────────────────────────────────────────────────────
EASY_LOC_IMPORT = "import 'package:easy_localization/easy_localization.dart';"

def apply_to_content(content: str, translations: dict) -> str:
    """Apply all translation replacements to dart content."""
    for eng, (key, _ar) in translations.items():
        esc = re.escape(eng)

        # 1. Text('...') trailing comma or close-paren
        content = re.sub(
            r"Text\(\s*'" + esc + r"'\s*([,\)])",
            lambda m, k=key: f"Text('{k}'.tr(){m.group(1)}",
            content,
        )
        content = re.sub(
            r'Text\(\s*"' + esc + r'"\s*([,\)])',
            lambda m, k=key: f"Text('{k}'.tr(){m.group(1)}",
            content,
        )

        # 2. hintText / labelText / helperText / tooltip: 'str'
        for field in ('hintText', 'labelText', 'helperText', 'tooltip'):
            content = re.sub(
                r"(" + field + r"\s*:\s*)'(" + esc + r")'",
                lambda m, k=key: f"{m.group(1)}'{k}'.tr()",
                content,
            )
            content = re.sub(
                r'(' + field + r'\s*:\s*)"(' + esc + r')"',
                lambda m, k=key: f"{m.group(1)}'{k}'.tr()",
                content,
            )

    return content


def ensure_import(content: str, fpath: Path) -> str:
    if EASY_LOC_IMPORT in content:
        return content
    if '.tr()' not in content:
        return content
    # Insert after first import block
    lines = content.split('\n')
    insert_at = 0
    for i, line in enumerate(lines):
        if line.startswith('import '):
            insert_at = i + 1
    lines.insert(insert_at, EASY_LOC_IMPORT)
    return '\n'.join(lines)


def is_ui_file(p: Path) -> bool:
    s = p.as_posix()
    if any(k in s for k in ['/data/', '/manager/', '/model/', '/repo/']):
        return False
    if any(k in p.name for k in ['cubit.dart', 'state.dart', 'bloc.dart']):
        return False
    return any(k in s for k in ['/ui/', '/screens/', '/widgets/', 'bottom_nav_bar', 'splash', 'auth'])


# ──────────────────────────────────────────────────────────────────────────────
# JSON update
# ──────────────────────────────────────────────────────────────────────────────
def update_json(translations: dict):
    en_path = ROOT / 'assets/translations/en.json'
    ar_path = ROOT / 'assets/translations/ar.json'

    en_data = json.loads(en_path.read_text(encoding='utf-8'))
    ar_data = json.loads(ar_path.read_text(encoding='utf-8'))

    added_en = added_ar = 0
    for eng, (key, ar) in translations.items():
        if key not in en_data:
            en_data[key] = eng
            added_en += 1
        if ar and key not in ar_data:
            ar_data[key] = ar
            added_ar += 1

    en_path.write_text(json.dumps(en_data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    ar_path.write_text(json.dumps(ar_data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f"JSON: +{added_en} en keys, +{added_ar} ar keys")


# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────
def main():
    update_json(TRANSLATIONS)

    ui_files = [p for p in (ROOT / 'lib').rglob('*.dart') if is_ui_file(p)]
    print(f"Processing {len(ui_files)} UI files …")

    changed = 0
    for fpath in ui_files:
        try:
            original = fpath.read_text(encoding='utf-8', errors='ignore')
        except Exception:
            continue

        updated = apply_to_content(original, TRANSLATIONS)
        updated = ensure_import(updated, fpath)

        if updated != original:
            fpath.write_text(updated, encoding='utf-8')
            changed += 1
            print(f"  ✓ {fpath}")

    print(f"\nDone. Modified {changed} / {len(ui_files)} files.")

if __name__ == '__main__':
    main()
