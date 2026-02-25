import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/glass_button.dart';
import 'auth_service.dart';
import 'account_setup_screen.dart';
import 'main.dart';

////////////////////////////////////////////////////////////
/// AUTH SCREEN LOCALIZATIONS
/// Self-contained so login/signup work before LangProvider
/// is mounted (they sit outside the main nav tree).
////////////////////////////////////////////////////////////

class AuthL10n {
  final String code;
  const AuthL10n(this.code);

  static const _t = <String, Map<String, String>>{
    // ── Brand ────────────────────────────────────────────
    "tagline": {
      "en": "Smart farming, rooted in data",
      "hi": "डेटा में जड़ें, खेती में आगे",
      "ta": "தரவில் வேரூன்றிய, நவீன விவசாயம்",
      "te": "డేటాలో వేళ్ళూనిన తెలివైన వ్యవసాయం",
      "kn": "ದತ್ತಾಂಶದಲ್ಲಿ ಬೇರೂರಿದ ಕೃಷಿ",
      "ml": "ഡേറ്റയിൽ വേരൂന്നിയ കൃഷി",
      "mr": "डेटात रुजलेली शेती",
      "gu": "ડેટામાં મૂળ ધરાવતી ખેતી",
      "pa": "ਡੇਟੇ ਵਿੱਚ ਜੜ੍ਹਾਂ ਵਾਲੀ ਖੇਤੀ",
      "bn": "তথ্যে শিকড় গাঁথা চাষাবাদ",
    },
    // ── Login screen ─────────────────────────────────────
    "login_credentials": {
      "en": "Login Credentials",
      "hi": "लॉगिन विवरण",
      "ta": "உள்நுழைவு விவரங்கள்",
      "te": "లాగిన్ వివరాలు",
      "kn": "ಲಾಗಿನ್ ವಿವರಗಳು",
      "ml": "ലോഗിൻ വിശദാംശങ്ങൾ",
      "mr": "लॉगिन तपशील",
      "gu": "લૉગિન વિગત",
      "pa": "ਲੌਗਇਨ ਵੇਰਵੇ",
      "bn": "লগইন তথ্য",
    },
    "phone": {
      "en": "Phone Number",
      "hi": "फ़ोन नंबर",
      "ta": "தொலைபேசி எண்",
      "te": "ఫోన్ నంబర్",
      "kn": "ಫೋನ್ ಸಂಖ್ಯೆ",
      "ml": "ഫോൺ നമ്പർ",
      "mr": "फोन नंबर",
      "gu": "ફોન નંબર",
      "pa": "ਫ਼ੋਨ ਨੰਬਰ",
      "bn": "ফোন নম্বর",
    },
    "password": {
      "en": "Password",
      "hi": "पासवर्ड",
      "ta": "கடவுச்சொல்",
      "te": "పాస్‌వర్డ్",
      "kn": "ಪಾಸ್‌ವರ್ಡ್",
      "ml": "പാസ്‌വേഡ്",
      "mr": "पासवर्ड",
      "gu": "પાસવર્ડ",
      "pa": "ਪਾਸਵਰਡ",
      "bn": "পাসওয়ার্ড",
    },
    "sign_in": {
      "en": "Sign In",
      "hi": "साइन इन करें",
      "ta": "உள்நுழைக",
      "te": "సైన్ ఇన్ చేయండి",
      "kn": "ಸೈನ್ ಇನ್ ಮಾಡಿ",
      "ml": "സൈൻ ഇൻ ചെയ്യുക",
      "mr": "साइन इन करा",
      "gu": "સાઇન ઇન કરો",
      "pa": "ਸਾਈਨ ਇਨ ਕਰੋ",
      "bn": "সাইন ইন করুন",
    },
    "new_here": {
      "en": "New here?",
      "hi": "नए हैं?",
      "ta": "புதியவரா?",
      "te": "కొత్తవారా?",
      "kn": "ಹೊಸಬರಾ?",
      "ml": "പുതിയ ആളാണോ?",
      "mr": "नवीन आहात का?",
      "gu": "નવા છો?",
      "pa": "ਨਵੇਂ ਹੋ?",
      "bn": "নতুন এখানে?",
    },
    "no_account": {
      "en": "Don't have an account?",
      "hi": "खाता नहीं है?",
      "ta": "கணக்கு இல்லையா?",
      "te": "ఖాతా లేదా?",
      "kn": "ಖಾತೆ ಇಲ್ಲವೇ?",
      "ml": "അക്കൗണ്ട് ഇല്ലേ?",
      "mr": "खाते नाही का?",
      "gu": "એકાઉન્ટ નથી?",
      "pa": "ਖਾਤਾ ਨਹੀਂ?",
      "bn": "অ্যাকাউন্ট নেই?",
    },
    "create_one": {
      "en": "Create one",
      "hi": "बनाएं",
      "ta": "உருவாக்குக",
      "te": "సృష్టించండి",
      "kn": "ರಚಿಸಿ",
      "ml": "ഉണ്ടാക്കൂ",
      "mr": "तयार करा",
      "gu": "બનાવો",
      "pa": "ਬਣਾਓ",
      "bn": "তৈরি করুন",
    },
    // ── Signup screen ─────────────────────────────────────
    "create_account": {
      "en": "Create Account",
      "hi": "खाता बनाएं",
      "ta": "கணக்கை உருவாக்கு",
      "te": "ఖాతా సృష్టించండి",
      "kn": "ಖಾತೆ ರಚಿಸಿ",
      "ml": "അക്കൗണ്ട് ഉണ്ടാക്കൂ",
      "mr": "खाते तयार करा",
      "gu": "એકાઉન્ટ બનાવો",
      "pa": "ਖਾਤਾ ਬਣਾਓ",
      "bn": "অ্যাকাউন্ট তৈরি করুন",
    },
    "join_tagline": {
      "en": "Join Krishi and grow smarter",
      "hi": "कृषि से जुड़ें, समझदारी से उगाएं",
      "ta": "கிருஷியில் இணைந்து மேலும் வளருங்கள்",
      "te": "కృషిలో చేరి తెలివిగా పెరగండి",
      "kn": "ಕೃಷಿ ಸೇರಿ ಬುದ್ಧಿವಂತಿಕೆಯಿಂದ ಬೆಳೆಯಿರಿ",
      "ml": "കൃഷിയിൽ ചേർന്ന് മിടുക്കോടെ വളരൂ",
      "mr": "कृषीत सामील व्हा आणि हुशारीने वाढा",
      "gu": "કૃષિ સાથે જોડાઓ અને સ્માર્ટ રીતે ઉગો",
      "pa": "ਕ੍ਰਿਸ਼ੀ ਨਾਲ ਜੁੜੋ ਅਤੇ ਸਮਝਦਾਰੀ ਨਾਲ ਵਧੋ",
      "bn": "কৃষিতে যোগ দিন এবং স্মার্টভাবে বাড়ুন",
    },
    "your_details": {
      "en": "Your details",
      "hi": "आपका विवरण",
      "ta": "உங்கள் விவரங்கள்",
      "te": "మీ వివరాలు",
      "kn": "ನಿಮ್ಮ ವಿವರಗಳು",
      "ml": "നിങ്ങളുടെ വിശദാംശങ്ങൾ",
      "mr": "तुमचे तपशील",
      "gu": "તમારી વિગત",
      "pa": "ਤੁਹਾਡੇ ਵੇਰਵੇ",
      "bn": "আপনার বিবরণ",
    },
    "all_required": {
      "en": "· all fields required",
      "hi": "· सभी फ़ील्ड ज़रूरी",
      "ta": "· அனைத்தும் தேவை",
      "te": "· అన్ని ఫీల్డ్‌లు అవసరం",
      "kn": "· ಎಲ್ಲಾ ಕ್ಷೇತ್ರಗಳು ಅಗತ್ಯ",
      "ml": "· എല്ലാ ഫീൽഡും നിർബന്ധം",
      "mr": "· सर्व फील्ड आवश्यक",
      "gu": "· બધાં ક્ષેત્ર ફ‍ળ",
      "pa": "· ਸਾਰੇ ਖੇਤਰ ਲਾਜ਼ਮੀ",
      "bn": "· সব ফিল্ড প্রয়োজনীয়",
    },
    "full_name": {
      "en": "Full Name",
      "hi": "पूरा नाम",
      "ta": "முழு பெயர்",
      "te": "పూర్తి పేరు",
      "kn": "ಪೂರ್ಣ ಹೆಸರು",
      "ml": "പൂർണ്ണ പേര്",
      "mr": "पूर्ण नाव",
      "gu": "પૂરું નામ",
      "pa": "ਪੂਰਾ ਨਾਮ",
      "bn": "পূর্ণ নাম",
    },
    "dob": {
      "en": "Date of Birth",
      "hi": "जन्म तिथि",
      "ta": "பிறந்த தேதி",
      "te": "పుట్టిన తేదీ",
      "kn": "ಹುಟ್ಟಿದ ದಿನಾಂಕ",
      "ml": "ജനനത്തീയതി",
      "mr": "जन्मतारीख",
      "gu": "જન્મ તારીખ",
      "pa": "ਜਨਮ ਮਿਤੀ",
      "bn": "জন্ম তারিখ",
    },
    "already_joined": {
      "en": "Already joined?",
      "hi": "पहले से जुड़े हैं?",
      "ta": "ஏற்கனவே இணைந்தீர்களா?",
      "te": "ఇప్పటికే చేరారా?",
      "kn": "ಈಗಾಗಲೇ ಸೇರಿದ್ದೀರಾ?",
      "ml": "ഇതിനകം ചേർന്നോ?",
      "mr": "आधीच सामील झालात का?",
      "gu": "પહેલેથી જોડાઈ ગયા?",
      "pa": "ਪਹਿਲਾਂ ਹੀ ਜੁੜ ਗਏ?",
      "bn": "ইতিমধ্যে যোগ দিয়েছেন?",
    },
    "have_account": {
      "en": "Already have an account?",
      "hi": "पहले से खाता है?",
      "ta": "ஏற்கனவே கணக்கு உள்ளதா?",
      "te": "ఇప్పటికే ఖాతా ఉందా?",
      "kn": "ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?",
      "ml": "ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ?",
      "mr": "आधीच खाते आहे का?",
      "gu": "પહેલેથી એકાઉન્ટ છે?",
      "pa": "ਪਹਿਲਾਂ ਤੋਂ ਖਾਤਾ ਹੈ?",
      "bn": "ইতিমধ্যে অ্যাকাউন্ট আছে?",
    },
    "sign_in_link": {
      "en": "Sign in",
      "hi": "साइन इन करें",
      "ta": "உள்நுழைக",
      "te": "సైన్ ఇన్",
      "kn": "ಸೈನ್ ಇನ್",
      "ml": "സൈൻ ഇൻ",
      "mr": "साइन इन करा",
      "gu": "સાઇન ઇન",
      "pa": "ਸਾਈਨ ਇਨ",
      "bn": "সাইন ইন",
    },
    // ── Errors ───────────────────────────────────────────
    "err_empty_login": {
      "en": "Please enter your phone and password.",
      "hi": "कृपया फ़ोन और पासवर्ड दर्ज करें।",
      "ta": "தொலைபேசி மற்றும் கடவுச்சொல் உள்ளிடவும்.",
      "te": "ఫోన్ మరియు పాస్‌వర్డ్ నమోదు చేయండి.",
      "kn": "ಫೋನ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ.",
      "ml": "ഫോൺ, പാസ്‌വേഡ് നൽകൂ.",
      "mr": "फोन आणि पासवर्ड प्रविष्ट करा.",
      "gu": "ફોન અને પાસવર્ડ દાખલ કરો.",
      "pa": "ਫ਼ੋਨ ਅਤੇ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ।",
      "bn": "ফোন ও পাসওয়ার্ড দিন।",
    },
    "err_empty_signup": {
      "en": "Please fill in all fields.",
      "hi": "कृपया सभी फ़ील्ड भरें।",
      "ta": "அனைத்து புலங்களையும் நிரப்பவும்.",
      "te": "అన్ని ఫీల్డ్‌లు పూరించండి.",
      "kn": "ಎಲ್ಲಾ ಕ್ಷೇತ್ರಗಳನ್ನು ತುಂಬಿ.",
      "ml": "എല്ലാ ഫീൽഡും പൂരിപ്പിക്കൂ.",
      "mr": "सर्व फील्ड भरा.",
      "gu": "બધાં ક્ષેત્ર ભરો.",
      "pa": "ਸਾਰੇ ਖੇਤਰ ਭਰੋ।",
      "bn": "সব ফিল্ড পূরণ করুন।",
    },
    "err_age": {
      "en": "You must be at least 15 years old.",
      "hi": "आपकी आयु कम से कम 15 वर्ष होनी चाहिए।",
      "ta": "உங்களுக்கு குறைந்தது 15 வயது இருக்க வேண்டும்.",
      "te": "మీకు కనీసం 15 సంవత్సరాలు ఉండాలి.",
      "kn": "ನಿಮ್ಮ ವಯಸ್ಸು ಕನಿಷ್ಠ 15 ಆಗಿರಬೇಕು.",
      "ml": "കുറഞ്ഞത് 15 വയസ്സ് ആയിരിക്കണം.",
      "mr": "वय किमान 15 वर्षे असणे आवश्यक आहे.",
      "gu": "ઉંમર ઓછામાં ઓછી 15 વર્ષ હોવી જોઈએ.",
      "pa": "ਉਮਰ ਘੱਟੋ-ਘੱਟ 15 ਸਾਲ ਹੋਣੀ ਚਾਹੀਦੀ ਹੈ।",
      "bn": "বয়স কমপক্ষে ১৫ বছর হতে হবে।",
    },
    "err_phone": {
      "en": "Please enter a valid Indian phone number.",
      "hi": "कृपया वैध भारतीय फ़ोन नंबर दर्ज करें।",
      "ta": "சரியான இந்திய தொலைபேசி எண் உள்ளிடவும்.",
      "te": "చెల్లుబాటు అయ్యే భారతీయ ఫోన్ నంబర్ నమోదు చేయండి.",
      "kn": "ಮಾನ್ಯ ಭಾರತೀಯ ಫೋನ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ.",
      "ml": "സാധുവായ ഇന്ത്യൻ ഫോൺ നംബർ നൽകൂ.",
      "mr": "वैध भारतीय फोन नंबर प्रविष्ट करा.",
      "gu": "માન્ય ભારતીય ફોન નંબર દાખલ કરો.",
      "pa": "ਸਹੀ ਭਾਰਤੀ ਫ਼ੋਨ ਨੰਬਰ ਦਰਜ ਕਰੋ।",
      "bn": "বৈধ ভারতীয় ফোন নম্বর দিন।",
    },
    "err_password": {
      "en": "Password must be at least 6 characters.",
      "hi": "पासवर्ड कम से कम 6 अक्षर का होना चाहिए।",
      "ta": "கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்.",
      "te": "పాస్‌వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి.",
      "kn": "ಪಾಸ್‌ವರ್ಡ್ ಕನಿಷ್ಠ 6 ಅಕ್ಷರ ಇರಬೇಕು.",
      "ml": "പാസ്‌വേഡ് ഏറ്റവും കുറഞ്ഞത് 6 അക്ഷരം ആയിരിക്കണം.",
      "mr": "पासवर्ड किमान 6 अक्षरांचा असावा.",
      "gu": "પાસવર્ડ ઓછામાં ઓછા 6 અક્ષરોનો હોવો જોઈએ.",
      "pa": "ਪਾਸਵਰਡ ਘੱਟੋ-ਘੱਟ 6 ਅੱਖਰਾਂ ਦਾ ਹੋਣਾ ਚਾਹੀਦਾ।",
      "bn": "পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে।",
    },
    "sign_in_failed": {
      "en": "Sign In Failed",
      "hi": "साइन इन विफल",
      "ta": "உள்நுழைவு தோல்வி",
      "te": "సైన్ ఇన్ విఫలమైంది",
      "kn": "ಸೈನ್ ಇನ್ ವಿಫಲ",
      "ml": "സൈൻ ഇൻ പരാജയം",
      "mr": "साइन इन अयशस्वी",
      "gu": "સાઇન ઇન નિષ્ફળ",
      "pa": "ਸਾਈਨ ਇਨ ਅਸਫਲ",
      "bn": "সাইন ইন ব্যর্থ",
    },
    "please_check": {
      "en": "Please Check",
      "hi": "कृपया जांचें",
      "ta": "சரிபார்க்கவும்",
      "te": "దయచేసి తనిఖీ చేయండి",
      "kn": "ದಯವಿಟ್ಟು ಪರಿಶೀಲಿಸಿ",
      "ml": "ദയവായി പരിശോധിക്കൂ",
      "mr": "कृपया तपासा",
      "gu": "કૃپால તપાસો",
      "pa": "ਕਿਰਪਾ ਕਰਕੇ ਜਾਂਚੋ",
      "bn": "অনুগ্রহ করে চেক করুন",
    },
    "try_again": {
      "en": "Try Again",
      "hi": "पुनः प्रयास करें",
      "ta": "மீண்டும் முயற்சிக்கவும்",
      "te": "మళ్ళీ ప్రయత్నించండి",
      "kn": "ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ",
      "ml": "വീണ്ടും ശ്രമിക്കൂ",
      "mr": "पुन्हा प्रयत्न करा",
      "gu": "ફરી પ્રયાસ કરો",
      "pa": "ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ",
      "bn": "আবার চেষ্টা করুন",
    },
    "got_it": {
      "en": "Got it",
      "hi": "समझ गया",
      "ta": "புரிந்தது",
      "te": "అర్థమైంది",
      "kn": "ಆಯ್ತು",
      "ml": "മനസ്സിലായി",
      "mr": "समजलं",
      "gu": "સમજ્યો",
      "pa": "ਸਮਝ ਗਿਆ",
      "bn": "বুঝেছি",
    },
    // ── Language picker ──────────────────────────────────
    "select_language": {
      "en": "Select Language",
      "hi": "भाषा चुनें",
      "ta": "மொழி தேர்வு",
      "te": "భాష ఎంచుకోండి",
      "kn": "ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ",
      "ml": "ഭാഷ തിരഞ്ഞെടുക്കുക",
      "mr": "भाषा निवडा",
      "gu": "ભાષા પસંદ કરો",
      "pa": "ਭਾਸ਼ਾ ਚੁਣੋ",
      "bn": "ভাষা বেছে নিন",
    },
  };

  String t(String key) => _t[key]?[code] ?? _t[key]?["en"] ?? key;
}

/// All 10 supported languages — same list as main.dart
const kLanguages = [
  {"code": "en", "name": "English",   "native": "English"},
  {"code": "hi", "name": "Hindi",     "native": "हिन्दी"},
  {"code": "ta", "name": "Tamil",     "native": "தமிழ்"},
  {"code": "te", "name": "Telugu",    "native": "తెలుగు"},
  {"code": "kn", "name": "Kannada",   "native": "ಕನ್ನಡ"},
  {"code": "ml", "name": "Malayalam", "native": "മലയാളം"},
  {"code": "mr", "name": "Marathi",   "native": "मराठी"},
  {"code": "gu", "name": "Gujarati",  "native": "ગુજરાતી"},
  {"code": "pa", "name": "Punjabi",   "native": "ਪੰਜਾਬੀ"},
  {"code": "bn", "name": "Bengali",   "native": "বাংলা"},
];

////////////////////////////////////////////////////////////
/// LANGUAGE PICKER SHEET  (self-contained, mirrors main.dart)
////////////////////////////////////////////////////////////

class AuthLangPickerSheet extends StatefulWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const AuthLangPickerSheet({required this.current, required this.onChanged});

  @override
  State<AuthLangPickerSheet> createState() => AuthLangPickerSheetState();
}

class AuthLangPickerSheetState extends State<AuthLangPickerSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        final glow = (math.sin(_shimmer.value * 2 * math.pi) + 1) / 2;
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF1A3040),
                    Color(0xFF203A43),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10 + 0.08 * glow),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Icon(Icons.language_rounded,
                        color: Colors.white.withOpacity(0.70), size: 17),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AuthL10n(_selected).t("select_language"),
                    style: GoogleFonts.dmSans(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: Colors.white, letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.14),
                    Colors.transparent,
                  ]),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.50),
                child: ListView(
                  shrinkWrap: true,
                  children: kLanguages.map((lang) {
                    final bool isSel = lang["code"] == _selected;
                    return GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        setState(() => _selected = lang["code"]!);
                        await LangStorage.save(lang["code"]!);
                        widget.onChanged(lang["code"]!);
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isSel
                              ? const Color(0xFF2C7A8C).withOpacity(0.35)
                              : Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: isSel
                                ? const Color(0xFF52B3C4).withOpacity(0.70)
                                : Colors.white.withOpacity(0.12),
                            width: isSel ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSel
                                    ? const Color(0xFF52B3C4)
                                    : Colors.white.withOpacity(0.25),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang["native"]!,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      fontWeight: isSel
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSel
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                  Text(
                                    lang["name"]!,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSel)
                              const Icon(Icons.check_rounded,
                                  color: Color(0xFF52B3C4), size: 18),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGIN SCREEN
////////////////////////////////////////////////////////////

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  final phoneController    = TextEditingController();
  final passwordController = TextEditingController();

  bool loading      = false;
  bool _obscureText = true;
  String _langCode  = "en";

  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnim;
  late Animation<Offset>  _slideAnim;
  late Animation<double>  _floatAnim;

  AuthL10n get _l => AuthL10n(_langCode);

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    // Load persisted language
    LangStorage.load().then((code) {
      if (mounted) setState(() => _langCode = code);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// LANGUAGE PICKER
  ////////////////////////////////////////////////////////////

  void _openLangPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      isScrollControlled: true,
      builder: (_) => AuthLangPickerSheet(
        current: _langCode,
        onChanged: (code) {
          if (mounted) setState(() => _langCode = code);
        },
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LOGIN
  ////////////////////////////////////////////////////////////

  Future<void> login() async {
    final phone    = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showError(_l.t("err_empty_login"));
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => loading = true);

    final error = await AuthService.login(phone: phone, password: password);
    setState(() => loading = false);

    if (error == null) {
      HapticFeedback.heavyImpact();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const KrishiAI()),
        (route) => false,
      );
    } else {
      _showError(error);
    }
  }

  void _showError(String message) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _ErrorDialog(message: message, langCode: _langCode),
    );
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: PremiumBackground(
        child: Stack(
          children: [
            _buildAmbientOrbs(),
            SafeArea(
              child: Stack(
                children: [
                  // ── Globe button top-right ──────────────
                  Positioned(
                    top: 12,
                    right: 16,
                    child: GestureDetector(
                      onTap: _openLangPicker,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.10),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.20)),
                        ),
                        child: const Icon(Icons.language_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),

                  // ── Main content ────────────────────────
                  Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 420),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildBrand(),
                                const SizedBox(height: 40),
                                _buildFields(),
                                const SizedBox(height: 20),
                                _buildLoginButton(),
                                const SizedBox(height: 24),
                                _buildDivider(),
                                const SizedBox(height: 24),
                                _buildCreateAccount(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// AMBIENT ORBS
  ////////////////////////////////////////////////////////////

  Widget _buildAmbientOrbs() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              bottom: -80 + _floatAnim.value * 0.4,
              left: -60,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF52B3C4).withOpacity(0.12),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              top: 100 + _floatAnim.value * 0.6,
              right: -40,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF2C7A8C).withOpacity(0.10),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// BRAND
  ////////////////////////////////////////////////////////////

  Widget _buildBrand() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value * 0.3),
        child: child,
      ),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.14),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                  color: Colors.white.withOpacity(0.20), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF52B3C4).withOpacity(0.20),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(Icons.grass_rounded,
                color: const Color(0xFF52B3C4).withOpacity(0.90), size: 30),
          ),
          const SizedBox(height: 18),
          Text("Krishi",
              style: GoogleFonts.dmSans(
                  fontSize: 38, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -1.2)),
          const SizedBox(height: 5),
          Text(_l.t("tagline"),
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.38),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2)),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELDS
  ////////////////////////////////////////////////////////////

  Widget _buildFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 3, height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF52B3C4).withOpacity(0.80),
                ),
              ),
              const SizedBox(width: 10),
              Text(_l.t("login_credentials"),
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.80),
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PremiumGlassTextField(
          controller: phoneController,
          labelText: _l.t("phone"),
          icon: Icons.phone_outlined,
          accentColor: const Color(0xFF52B3C4),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        PremiumGlassTextField(
          controller: passwordController,
          labelText: _l.t("password"),
          icon: Icons.lock_outline_rounded,
          accentColor: const Color(0xFF52B3C4),
          obscureText: _obscureText,
          suffixIcon: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _obscureText = !_obscureText);
            },
            child: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
              color: Colors.white.withOpacity(0.40),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// LOGIN BUTTON
  ////////////////////////////////////////////////////////////

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final shimmer =
            (math.sin(_shimmerController.value * 2 * math.pi) + 1) / 2;
        return GestureDetector(
          onTap: loading ? null : login,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: loading
                  ? LinearGradient(colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.03),
                    ])
                  : LinearGradient(
                      colors: [
                        Color.lerp(const Color(0xFF2C7A8C),
                            const Color(0xFF3A8FA0), shimmer * 0.3)!,
                        const Color(0xFF1E5F70),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              boxShadow: loading
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF1E5F70).withOpacity(0.45),
                        blurRadius: 20, offset: const Offset(0, 7),
                      ),
                      BoxShadow(
                        color: const Color(0xFF52B3C4)
                            .withOpacity(0.15 + 0.10 * shimmer),
                        blurRadius: 35, offset: const Offset(0, 4),
                      ),
                    ],
              border: loading
                  ? null
                  : Border.all(
                      color: Colors.white.withOpacity(0.15 + 0.08 * shimmer),
                      width: 1.0),
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0, color: Colors.white54))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_l.t("sign_in"),
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.5, letterSpacing: 0.2)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white.withOpacity(0.80), size: 17),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// DIVIDER
  ////////////////////////////////////////////////////////////

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent, Colors.white.withOpacity(0.12),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(_l.t("new_here"),
              style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.28),
                  fontWeight: FontWeight.w400)),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white.withOpacity(0.12), Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// CREATE ACCOUNT
  ////////////////////////////////////////////////////////////

  Widget _buildCreateAccount() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSetupScreen(
              phone: "",
              uid: "",
              initialLangCode: _langCode,
            ),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, _) {
          final shimmer =
              (math.sin(_shimmerController.value * 2 * math.pi) + 1) / 2;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                  color: Colors.white.withOpacity(0.08 + 0.05 * shimmer)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_l.t("no_account"),
                    style: GoogleFonts.dmSans(
                        fontSize: 13.5,
                        color: Colors.white.withOpacity(0.38))),
                const SizedBox(width: 6),
                Text(_l.t("create_one"),
                    style: GoogleFonts.dmSans(
                        fontSize: 13.5,
                        color: const Color(0xFF52B3C4).withOpacity(0.90),
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: const Color(0xFF52B3C4).withOpacity(0.70)),
              ],
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ERROR DIALOG
////////////////////////////////////////////////////////////

class _ErrorDialog extends StatefulWidget {
  final String message;
  final String langCode;
  const _ErrorDialog({required this.message, required this.langCode});

  @override
  State<_ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<_ErrorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380))
      ..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AuthL10n(widget.langCode);
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 30, 26, 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF1A3040),
                      Color(0xFF203A43),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.40),
                        blurRadius: 40, offset: const Offset(0, 12)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Icon(Icons.info_outline_rounded,
                          color: Colors.white.withOpacity(0.55), size: 22),
                    ),
                    const SizedBox(height: 16),
                    Text(l.t("sign_in_failed"),
                        style: GoogleFonts.dmSans(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: Colors.white, letterSpacing: -0.2)),
                    const SizedBox(height: 8),
                    Text(widget.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            fontSize: 13.5,
                            color: Colors.white.withOpacity(0.45),
                            height: 1.5)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18)),
                        ),
                        child: Center(
                          child: Text(l.t("try_again"),
                              style: GoogleFonts.dmSans(
                                  color: Colors.white.withOpacity(0.80),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}