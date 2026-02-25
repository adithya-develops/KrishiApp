import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart'; // LangProvider, AppLocalizations

// ═══════════════════════════════════════════════════════════════════════════
//  TRANSLATIONS  —  All UI strings in 10 languages
// ═══════════════════════════════════════════════════════════════════════════

class _T {
  static String tapForGuidance(String lang) => const {
    "en": "Tap for detailed guidance",
    "hi": "विस्तृत मार्गदर्शन के लिए टैप करें",
    "ta": "விரிவான வழிகாட்டுதலுக்கு தட்டவும்",
    "te": "వివరణాత్మక మార్గదర్శనం కోసం నొక్కండి",
    "kn": "ವಿವರವಾದ ಮಾರ್ಗದರ್ಶನಕ್ಕಾಗಿ ತಟ್ಟಿ",
    "ml": "വിശദമായ നിർദ്ദേശത്തിന് ടാപ്പ് ചെയ്യുക",
    "mr": "तपशीलवार मार्गदर्शनासाठी टॅप करा",
    "gu": "વિગતવાર માર્ગદર્શન માટે ટૅપ કરો",
    "pa": "ਵਿਸਤ੍ਰਿਤ ਮਾਰਗਦਰਸ਼ਨ ਲਈ ਟੈਪ ਕਰੋ",
    "bn": "বিস্তারিত নির্দেশের জন্য ট্যাপ করুন",
  }[lang] ?? "Tap for detailed guidance";
}

// ═══════════════════════════════════════════════════════════════════════════
//  DATA  —  Per-soil fertilizer & amendment details (all 10 languages)
// ═══════════════════════════════════════════════════════════════════════════

class _SoilDetailData {

  // ── Label translations ──────────────────────────────────────────────────
  static const Map<String, Map<String, String>> _labels = {
    // Fertilizer labels
    "Primary NPK": {
      "en": "Primary NPK", "hi": "प्राथमिक NPK", "ta": "முதன்மை NPK",
      "te": "ప్రాథమిక NPK", "kn": "ಪ್ರಾಥಮಿಕ NPK", "ml": "പ്രാഥമിക NPK",
      "mr": "प्राथमिक NPK", "gu": "પ્રાથમિક NPK", "pa": "ਪ੍ਰਾਇਮਰੀ NPK", "bn": "প্রাথমিক NPK",
    },
    "Nitrogen Source": {
      "en": "Nitrogen Source", "hi": "नाइट्रोजन स्रोत", "ta": "நைட்ரஜன் மூலம்",
      "te": "నైట్రోజన్ మూలం", "kn": "ನೈಟ್ರೋಜನ್ ಮೂಲ", "ml": "നൈട്രജൻ സ്രോതസ്സ്",
      "mr": "नायट्रोजन स्रोत", "gu": "નાઈટ્રોજન સ્ત્રોત", "pa": "ਨਾਈਟ੍ਰੋਜਨ ਸਰੋਤ", "bn": "নাইট্রোজেন উৎস",
    },
    "Organic Supplement": {
      "en": "Organic Supplement", "hi": "जैविक पूरक", "ta": "கரிம சேர்க்கை",
      "te": "సేంద్రీయ అనుబంధం", "kn": "ಸಾವಯವ ಪೂರಕ", "ml": "ജൈവ അനുബന്ധം",
      "mr": "सेंद्रिय पूरक", "gu": "ઓર્ગેનિક સપ્લિમેન્ટ", "pa": "ਜੈਵਿਕ ਪੂਰਕ", "bn": "জৈব সম্পূরক",
    },
    "Biofertilizers": {
      "en": "Biofertilizers", "hi": "जैव उर्वरक", "ta": "உயிர் உரங்கள்",
      "te": "జీవ ఎరువులు", "kn": "ಜೈವಿಕ ಗೊಬ್ಬರ", "ml": "ജൈവ വളം",
      "mr": "जैव खते", "gu": "જૈવ ખાતર", "pa": "ਜੀਵ ਖਾਦ", "bn": "জৈব সার",
    },
    "Watch For": {
      "en": "Watch For", "hi": "ध्यान दें", "ta": "கவனிக்கவும்",
      "te": "జాగ్రత్తగా ఉండండి", "kn": "ಗಮನಿಸಿ", "ml": "ശ്രദ്ധിക്കുക",
      "mr": "लक्ष द्या", "gu": "ધ્યાન આપો", "pa": "ਧਿਆਨ ਦਿਓ", "bn": "সাবধানতা",
    },
    "Lime to Correct Acidity": {
      "en": "Lime to Correct Acidity", "hi": "अम्लता सुधारने के लिए चूना",
      "ta": "அமிலத்தன்மை சரிசெய்ய சுண்ணாம்பு", "te": "ఆమ్లత్వం సరిదిద్దడానికి సుద్ద",
      "kn": "ಆಮ್ಲೀಯತೆ ಸರಿಪಡಿಸಲು ಸುಣ್ಣ", "ml": "അമ്ലത ശരിയാക്കാൻ ചുണ്ണാമ്പ്",
      "mr": "आम्लता सुधारण्यासाठी चुना", "gu": "એસિડિટી સુધારવા ચૂનો",
      "pa": "ਐਸਿਡਿਟੀ ਸੁਧਾਰਨ ਲਈ ਚੂਨਾ", "bn": "অম্লতা সংশোধনে চুন",
    },
    "Organic Manure": {
      "en": "Organic Manure", "hi": "जैविक खाद", "ta": "கரிம உரம்",
      "te": "సేంద్రీయ ఎరువు", "kn": "ಸಾವಯವ ಗೊಬ್ಬರ", "ml": "ജൈവ വളം",
      "mr": "सेंद्रिय खत", "gu": "ઓર્ગેનિક ખાતર", "pa": "ਜੈਵਿਕ ਖਾਦ", "bn": "জৈব সার",
    },
    "Micronutrients": {
      "en": "Micronutrients", "hi": "सूक्ष्म पोषक तत्व", "ta": "நுண்ணூட்டச்சத்துகள்",
      "te": "సూక్ష్మ పోషకాలు", "kn": "ಸೂಕ್ಷ್ಮ ಪೋಷಕಾಂಶಗಳು", "ml": "സൂക്ഷ്മ പോഷകങ്ങൾ",
      "mr": "सूक्ष्म अन्नद्रव्ये", "gu": "સૂક્ષ્મ પોષકતત્વો", "pa": "ਸੂਖਮ ਪੌਸ਼ਟਿਕ ਤੱਤ", "bn": "অণু পুষ্টি",
    },
    "Nitrogen Timing": {
      "en": "Nitrogen Timing", "hi": "नाइट्रोजन देने का समय", "ta": "நைட்ரஜன் கொடுக்கும் நேரம்",
      "te": "నైట్రోజన్ సమయం", "kn": "ನೈಟ್ರೋಜನ್ ಸಮಯ", "ml": "നൈട്രജൻ സമയം",
      "mr": "नायट्रोजन वेळ", "gu": "નાઈટ્રોજન સમય", "pa": "ਨਾਈਟ੍ਰੋਜਨ ਸਮਾਂ", "bn": "নাইট্রোজেন সময়",
    },
    "Organic Matter": {
      "en": "Organic Matter", "hi": "जैविक पदार्थ", "ta": "கரிமப் பொருள்",
      "te": "సేంద్రీయ పదార్థం", "kn": "ಸಾವಯವ ವಸ್ತು", "ml": "ജൈവ പദാർഥം",
      "mr": "सेंद्रिय घटक", "gu": "ઓર્ગેનિક પદાર્થ", "pa": "ਜੈਵਿਕ ਪਦਾਰਥ", "bn": "জৈব পদার্থ",
    },
    "Zinc Deficiency": {
      "en": "Zinc Deficiency", "hi": "जिंक की कमी", "ta": "துத்தநாக குறைபாடு",
      "te": "జింక్ లోపం", "kn": "ಜಿಂಕ್ ಕೊರತೆ", "ml": "സിങ്ക് കുറവ്",
      "mr": "Zinc ची कमतरता", "gu": "ઝિંકની ઉણપ", "pa": "ਜ਼ਿੰਕ ਦੀ ਕਮੀ", "bn": "জিঙ্ক ঘাটতি",
    },
    "Lime Application": {
      "en": "Lime Application", "hi": "चूना प्रयोग", "ta": "சுண்ணாம்பு பயன்பாடு",
      "te": "సుద్ద వినియోగం", "kn": "ಸುಣ್ಣ ಅನ್ವಯ", "ml": "ചുണ്ണാമ്പ് പ്രയോഗം",
      "mr": "चुना वापर", "gu": "ચૂના ઉપયોગ", "pa": "ਚੂਨਾ ਪ੍ਰਯੋਗ", "bn": "চুন প্রয়োগ",
    },
    "Organic Matter is Critical": {
      "en": "Organic Matter is Critical", "hi": "जैविक पदार्थ अत्यंत जरूरी",
      "ta": "கரிமப் பொருள் மிக முக்கியம்", "te": "సేంద్రీయ పదార్థం చాలా అవసరం",
      "kn": "ಸಾವಯವ ವಸ್ತು ಅತ್ಯಗತ್ಯ", "ml": "ജൈവ പദാർഥം അനിവാര്യം",
      "mr": "सेंद्रिय घटक अत्यंत महत्त्वाचे", "gu": "ઓર્ગેનિક પદાર્થ અત્યંત જરૂરી",
      "pa": "ਜੈਵਿਕ ਪਦਾਰਥ ਬਹੁਤ ਜ਼ਰੂਰੀ", "bn": "জৈব পদার্থ অত্যন্ত গুরুত্বপূর্ণ",
    },
    "Phosphorus Management": {
      "en": "Phosphorus Management", "hi": "फास्फोरस प्रबंधन", "ta": "பாஸ்பரஸ் மேலாண்மை",
      "te": "ఫాస్ఫరస్ నిర్వహణ", "kn": "ರಂಜಕ ನಿರ್ವಹಣೆ", "ml": "ഫോസ്ഫറസ് മാനേജ്മെന്റ്",
      "mr": "फॉस्फरस व्यवस्थापन", "gu": "ફોસ્ફરસ વ્યવસ્થાપન", "pa": "ਫਾਸਫੋਰਸ ਪ੍ਰਬੰਧਨ", "bn": "ফসফরাস ব্যবস্থাপনা",
    },
    "Nitrogen Strategy": {
      "en": "Nitrogen Strategy", "hi": "नाइट्रोजन रणनीति", "ta": "நைட்ரஜன் உத்தி",
      "te": "నైట్రోజన్ వ్యూహం", "kn": "ನೈಟ್ರೋಜನ್ ತಂತ್ರ", "ml": "നൈട്രജൻ തന്ത്രം",
      "mr": "नायट्रोजन धोरण", "gu": "નાઈટ્રોજન વ્યૂહ", "pa": "ਨਾਈਟ੍ਰੋਜਨ ਰਣਨੀਤੀ", "bn": "নাইট্রোজেন কৌশল",
    },
    "Micronutrient Status": {
      "en": "Micronutrient Status", "hi": "सूक्ष्म पोषक स्थिति", "ta": "நுண்ணூட்டச்சத்து நிலை",
      "te": "సూక్ష్మ పోషక స్థితి", "kn": "ಸೂಕ್ಷ್ಮ ಪೋಷಕ ಸ್ಥಿತಿ", "ml": "സൂക്ഷ്മ പോഷക നില",
      "mr": "सूक्ष्म अन्नद्रव्य स्थिती", "gu": "સૂક્ષ્મ પોષક સ્થિતિ", "pa": "ਸੂਖਮ ਪੋਸ਼ਕ ਸਥਿਤੀ", "bn": "অণু পুষ্টির অবস্থা",
    },
    "Acidic pH Management": {
      "en": "Acidic pH Management", "hi": "अम्लीय pH प्रबंधन", "ta": "அமிலத்தன்மை pH மேலாண்மை",
      "te": "ఆమ్ల pH నిర్వహణ", "kn": "ಆಮ್ಲ pH ನಿರ್ವಹಣೆ", "ml": "ആസിഡ് pH മാനേജ്മെന്റ്",
      "mr": "आम्ल pH व्यवस्थापन", "gu": "એસિડ pH વ્યવસ્થાપન", "pa": "ਐਸਿਡ pH ਪ੍ਰਬੰਧਨ", "bn": "অম্ল pH ব্যবস্থাপনা",
    },
    "Application Method Matters": {
      "en": "Application Method Matters", "hi": "प्रयोग विधि महत्वपूर्ण",
      "ta": "பயன்படுத்தும் முறை முக்கியம்", "te": "వినియోగ పద్ధతి ముఖ్యం",
      "kn": "ಅನ್ವಯ ವಿಧಾನ ಮುಖ್ಯ", "ml": "പ്രയോഗ രീതി പ്രധാനം",
      "mr": "वापर पद्धत महत्त्वाची", "gu": "ઉપયોગ પદ્ધતિ મહત્વની", "pa": "ਪ੍ਰਯੋਗ ਵਿਧੀ ਮਹੱਤਵਪੂਰਨ", "bn": "প্রয়োগ পদ্ধতি গুরুত্বপূর্ণ",
    },
    "Choose Fertilisers Carefully": {
      "en": "Choose Fertilisers Carefully", "hi": "उर्वरक सोच-समझकर चुनें",
      "ta": "உரங்களை கவனமாக தேர்ந்தெடுக்கவும்", "te": "ఎరువులను జాగ్రత్తగా ఎంచుకోండి",
      "kn": "ಗೊಬ್ಬರ ಎಚ್ಚರಿಕೆಯಿಂದ ಆರಿಸಿ", "ml": "വളം ശ്രദ്ധയോടെ തിരഞ്ഞെടുക്കുക",
      "mr": "खते काळजीपूर्वक निवडा", "gu": "ખાતર કાળજીથી પસંદ કરો", "pa": "ਖਾਦ ਸੋਚ ਕੇ ਚੁਣੋ", "bn": "সার সতর্কভাবে বেছে নিন",
    },
    "Gypsum — The Key Chemical": {
      "en": "Gypsum — The Key Chemical", "hi": "जिप्सम — मुख्य रसायन",
      "ta": "ஜிப்சம் — முக்கிய ரசாயனம்", "te": "జిప్సమ్ — కీలక రసాయనం",
      "kn": "ಜಿಪ್ಸಮ್ — ಮುಖ್ಯ ರಾಸಾಯನಿಕ", "ml": "ജിപ്സം — പ്രധാന രാസവസ്തു",
      "mr": "जिप्सम — मुख्य रसायन", "gu": "જીપ્સમ — મુખ્ય રસાયન", "pa": "ਜਿਪਸਮ — ਮੁੱਖ ਰਸਾਇਣ", "bn": "জিপসাম — মূল রাসায়নিক",
    },
    "Organic Amendments": {
      "en": "Organic Amendments", "hi": "जैविक संशोधन", "ta": "கரிம திருத்தங்கள்",
      "te": "సేంద్రీయ సంశోధనలు", "kn": "ಸಾವಯವ ತಿದ್ದುಪಡಿ", "ml": "ജൈവ ഭേദഗതികൾ",
      "mr": "सेंद्रिय दुरुस्त्या", "gu": "ઓર્ગેનિક સુધારા", "pa": "ਜੈਵਿਕ ਸੋਧ", "bn": "জৈব সংশোধন",
    },
    "Pyrite for Calcareous Soils": {
      "en": "Pyrite for Calcareous Soils", "hi": "चूनेदार मिट्टी के लिए पायराइट",
      "ta": "சுண்ணாம்பு மண்ணுக்கு பைரைட்", "te": "సున్నపు నేలకు పైరైట్",
      "kn": "ಸುಣ್ಣ ಮಣ್ಣಿಗೆ ಪೈರೈಟ್", "ml": "കുമ്മായ മണ്ണിന് പൈറൈറ്റ്",
      "mr": "चुनखडी मातीसाठी पायराइट", "gu": "ચૂનાયુક્ત જમીન માટે પાઈરાઈટ", "pa": "ਚੂਨੇਦਾਰ ਮਿੱਟੀ ਲਈ ਪਾਇਰਾਈਟ", "bn": "চুনাপাথুরে মাটিতে পাইরাইট",
    },
    "General Recommendation": {
      "en": "General Recommendation", "hi": "सामान्य सिफारिश", "ta": "பொது பரிந்துரை",
      "te": "సాధారణ సిఫార్సు", "kn": "ಸಾಮಾನ್ಯ ಶಿಫಾರಸು", "ml": "പൊതു ശുപാർശ",
      "mr": "सामान्य शिफारस", "gu": "સામાન્ય ભલામણ", "pa": "ਆਮ ਸਿਫਾਰਸ਼", "bn": "সাধারণ সুপারিশ",
    },
    // Amendment labels
    "Crop Rotation": {
      "en": "Crop Rotation", "hi": "फसल चक्र", "ta": "பயிர் சுழற்சி",
      "te": "పంట మార్పిడి", "kn": "ಬೆಳೆ ಪರಿವರ್ತನೆ", "ml": "വിള ഭ്രമണം",
      "mr": "पीक फेरबदल", "gu": "પાક ચક્ર", "pa": "ਫ਼ਸਲ ਚੱਕਰ", "bn": "ফসল আবর্তন",
    },
    "Green Manuring": {
      "en": "Green Manuring", "hi": "हरी खाद", "ta": "பசுந்தாள் உரம்",
      "te": "పచ్చిరొట్ట ఎరువు", "kn": "ಹಸಿರು ಗೊಬ್ಬರ", "ml": "ഹരിത വളം",
      "mr": "हिरवी खत", "gu": "લીલો ખાતર", "pa": "ਹਰੀ ਖਾਦ", "bn": "সবুজ সার",
    },
    "Irrigation Practice": {
      "en": "Irrigation Practice", "hi": "सिंचाई अभ्यास", "ta": "நீர்ப்பாசன முறை",
      "te": "సాగునీటి పద్ధతి", "kn": "ನೀರಾವರಿ ಅಭ್ಯಾಸ", "ml": "ജലസേചന രീതി",
      "mr": "सिंचन पद्धत", "gu": "સિંચાઈ પ્રથા", "pa": "ਸਿੰਚਾਈ ਅਭਿਆਸ", "bn": "সেচ অনুশীলন",
    },
    "Water Conservation": {
      "en": "Water Conservation", "hi": "जल संरक्षण", "ta": "நீர் பாதுகாப்பு",
      "te": "నీటి సంరక్షణ", "kn": "ನೀರಿನ ಸಂರಕ್ಷಣೆ", "ml": "ജല സംരക்ஷணம்",
      "mr": "जलसंधारण", "gu": "જળ સંરक्षण", "pa": "ਪਾਣੀ ਦੀ ਸੰਭਾਲ", "bn": "জল সংরক্ষণ",
    },
    "Soil Structure": {
      "en": "Soil Structure", "hi": "मिट्टी की संरचना", "ta": "மண் அமைப்பு",
      "te": "నేల నిర్మాణం", "kn": "ಮಣ್ಣಿನ ರಚನೆ", "ml": "മണ്ണിന്റെ ഘടന",
      "mr": "मातीची रचना", "gu": "માટીની રચना", "pa": "ਮਿੱਟੀ ਦੀ ਬਣਤਰ", "bn": "মাটির গঠন",
    },
    "Gypsum for Drainage": {
      "en": "Gypsum for Drainage", "hi": "जल निकासी के लिए जिप्सम", "ta": "வடிகாலுக்கு ஜிப்சம்",
      "te": "నీటిపారుదలకు జిప్సమ్", "kn": "ಒಳಚರಂಡಿಗೆ ಜಿಪ್ಸಮ್", "ml": "ഡ്രെയിനേജിന് ജിപ്സം",
      "mr": "निचऱ्यासाठी जिप्सम", "gu": "ડ્રેનેજ માટે જીપ્સમ", "pa": "ਨਿਕਾਸੀ ਲਈ ਜਿਪਸਮ", "bn": "নিষ্কাশনে জিপসাম",
    },
    "Tillage Timing is Critical": {
      "en": "Tillage Timing is Critical", "hi": "जुताई का समय महत्वपूर्ण",
      "ta": "உழவு நேரம் முக்கியம்", "te": "దున్నే సమయం కీలకం",
      "kn": "ಉಳುಮೆ ಸಮಯ ಮಹತ್ವದ", "ml": "ഉഴവ് സമയം നിർണ്ണായകം",
      "mr": "मशागतीचा वेळ महत्त्वाचा", "gu": "ખેડ સમય મહત્વનો", "pa": "ਵਾਹੀ ਸਮਾਂ ਅਹਿਮ", "bn": "চাষের সময় গুরুত্বপূর্ণ",
    },
    "Drainage Improvement": {
      "en": "Drainage Improvement", "hi": "जल निकासी सुधार", "ta": "வடிகால் மேம்பாடு",
      "te": "నీటిపారుదల మెరుగుదల", "kn": "ಒಳಚರಂಡಿ ಸುಧಾರಣೆ", "ml": "ഡ്രെയിനേജ് മെച്ചപ്പെടുത്തൽ",
      "mr": "निचरा सुधारणा", "gu": "ડ્રેનેજ સુધારણા", "pa": "ਨਿਕਾਸੀ ਸੁਧਾਰ", "bn": "নিষ্কাশন উন্নতি",
    },
    "Cover Crops in Fallow": {
      "en": "Cover Crops in Fallow", "hi": "परती में आवरण फसल", "ta": "தரிசு நிலத்தில் ஆவரண பயிர்",
      "te": "పడావు భూమిలో కప్పు పంట", "kn": "ಪಾಳು ಜಮೀನಿನಲ್ಲಿ ಹೊದಿಕೆ ಬೆಳೆ", "ml": "തരിശ് ഭൂമിയിൽ കവർ ക്രോപ്പ്",
      "mr": "पडीक जमिनीत आच्छादन पीक", "gu": "પડતર જમીનમાં આચ્છાદક પાક", "pa": "ਬੰਜਰ ਜ਼ਮੀਨ ਵਿੱਚ ਕਵਰ ਫ਼ਸਲ", "bn": "পতিত জমিতে আবরণ ফসল",
    },
    "Organic Matter Addition": {
      "en": "Organic Matter Addition", "hi": "जैविक पदार्थ जोड़ना", "ta": "கரிமப் பொருள் சேர்த்தல்",
      "te": "సేంద్రీయ పదార్థ చేర్పు", "kn": "ಸಾವಯವ ವಸ್ತು ಸೇರ್ಪಡೆ", "ml": "ജൈവ പദാർഥം ചേർക്കൽ",
      "mr": "सेंद्रिय घटक वाढवणे", "gu": "ઓર્ગેनिक પдаर्थ ઉмेरণ", "pa": "ਜੈਵਿਕ ਪਦਾਰਥ ਜੋੜਨਾ", "bn": "জৈব পদার্থ যোগ করা",
    },
    "Cover Cropping": {
      "en": "Cover Cropping", "hi": "आवरण फसल", "ta": "ஆவரண பயிர்",
      "te": "కప్పు పంట", "kn": "ಹೊದಿಕೆ ಬೆಳೆ", "ml": "കവർ ക്രോപ്പ്",
      "mr": "आच्छादन पीक", "gu": "આчार पाک", "pa": "ਕਵਰ ਫ਼ਸਲ", "bn": "আবরণ ফসল",
    },
    "Contour Bunds & Terracing": {
      "en": "Contour Bunds & Terracing", "hi": "समोच्च बंध और सीढ़ीदार खेती",
      "ta": "கான்டூர் அணைக்கட்டு & படிகள்", "te": "కంటూర్ బండ్లు & మెట్లు",
      "kn": "ಕಂಟೂರ್ ಬಂಡ್ & ಮೆಟ್ಟಿಲು", "ml": "കൺടൂർ ബണ്ട് & ടെറസിങ്",
      "mr": "समोच्च बांध व सोपान शेती", "gu": "Contour Bund & Terracing", "pa": "ਕੰਟੋਰ ਬੰਧ ਤੇ ਟੈਰੇਸਿੰਗ", "bn": "কনটুর বাঁধ ও টেরেসিং",
    },
    "Sub-soiling": {
      "en": "Sub-soiling", "hi": "उपमृदा जुताई", "ta": "ஆழ் உழவு",
      "te": "సబ్-సాయిలింగ్", "kn": "ಆಳ ಉಳುಮೆ", "ml": "ആഴം ഉഴവ്",
      "mr": "उपमृदा मशागत", "gu": "ઊંડી ખेड", "pa": "ਡੂੰਘੀ ਵਾਹੀ", "bn": "উপ-মৃত্তিকা কর্ষণ",
    },
    "Water Harvesting First": {
      "en": "Water Harvesting First", "hi": "पहले जल संचयन", "ta": "முதலில் நீர் சேகரிப்பு",
      "te": "మొదట నీటి సంగ్రహణ", "kn": "ಮೊದಲು ನೀರು ಕೊಯ್ಲು", "ml": "ആദ്യം ജലസംഭരണം",
      "mr": "प्रथम जलसंधारण", "gu": "પ્રથમ જળ સंचय", "pa": "ਪਹਿਲਾਂ ਪਾਣੀ ਇਕੱਠਾ ਕਰੋ", "bn": "প্রথমে জল সংগ্রহ",
    },
    "Organic Matter Build-up": {
      "en": "Organic Matter Build-up", "hi": "जैविक पदार्थ निर्माण", "ta": "கரிமப் பொருள் சேர்த்தல்",
      "te": "సేంద్రీయ పదార్థ నిర్మాణం", "kn": "ಸಾವಯವ ವಸ್ತು ಹೆಚ್ಚಳ", "ml": "ജൈവ പദാർഥ ശേഖരണം",
      "mr": "सेंद्रिय घटक वाढवणे", "gu": "ઓर्ганिक мाटेरियल ऊر्जा", "pa": "ਜੈਵਿਕ ਪਦਾਰਥ ਵਧਾਉਣਾ", "bn": "জৈব পদার্থ বৃদ্ধি",
    },
    "Irrigation Efficiency": {
      "en": "Irrigation Efficiency", "hi": "सिंचाई दक्षता", "ta": "நீர்ப்பாசன திறன்",
      "te": "సాగునీటి సామర్థ్యం", "kn": "ನೀರಾವರಿ ದಕ್ಷತೆ", "ml": "ജലസേചന ക്ഷമത",
      "mr": "सिंचनाची कार्यक्षमता", "gu": "સિંchaisнी ક્ષмता", "pa": "ਸਿੰਚਾਈ ਕੁਸ਼ਲਤਾ", "bn": "সেচ দক্ষতা",
    },
    "Windbreak Planting": {
      "en": "Windbreak Planting", "hi": "वायुरोधक रोपण", "ta": "காற்று தடுப்பு நடவு",
      "te": "వాతాయన అడ్డకట్ట నాటడం", "kn": "ಗಾಳಿ ತಡೆ ನೆಡುವಿಕೆ", "ml": "കാറ്റ് തടസ്സ നടീൽ",
      "mr": "वातावरण अडथळा लागवड", "gu": "Windbreak Planting", "pa": "ਹਵਾ ਰੋਕ ਰੁੱਖ ਲਗਾਉਣਾ", "bn": "বায়ু প্রতিরোধক রোপণ",
    },
    "Terracing — Most Important": {
      "en": "Terracing — Most Important", "hi": "सीढ़ीदार खेती — सबसे महत्वपूर्ण",
      "ta": "படிவான சாகுபடி — மிக முக்கியம்", "te": "మెట్ల వ్యవసాయం — అత్యంత ముఖ్యం",
      "kn": "ಮೆಟ್ಟಿಲು ಕೃಷಿ — ಅತ್ಯಂತ ಮಹತ್ವದ", "ml": "ടെറസ് കൃഷി — ഏറ്റവും പ്രധാനം",
      "mr": "सोपान शेती — सर्वात महत्त्वाचे", "gu": "Terracing — Most Important", "pa": "ਟੈਰੇਸਿੰਗ — ਸਭ ਤੋਂ ਮਹੱਤਵਪੂਰਨ", "bn": "টেরেসিং — সর্বাধিক গুরুত্বপূর্ণ",
    },
    "Contour Farming": {
      "en": "Contour Farming", "hi": "समोच्च खेती", "ta": "கான்டூர் சாகுபடி",
      "te": "కంటూర్ వ్యవసాయం", "kn": "ಕಂಟೂರ್ ಕೃಷಿ", "ml": "കൺടൂർ കൃഷി",
      "mr": "समोच्च शेती", "gu": "Contour Farming", "pa": "ਕੰਟੋਰ ਖੇਤੀ", "bn": "কনটুর চাষ",
    },
    "Forest Cover Maintenance": {
      "en": "Forest Cover Maintenance", "hi": "वन आवरण रखरखाव", "ta": "வன மூடிகை பராமரிப்பு",
      "te": "అడవి కప్పు నిర్వహణ", "kn": "ಅರಣ್ಯ ಹೊದಿಕೆ ನಿರ್ವಹಣೆ", "ml": "വനം കവർ പരിപാലനം",
      "mr": "वन आच्छादन देखभाल", "gu": "Forest Cover Maintenance", "pa": "ਜੰਗਲੀ ਢੱਕਣ ਰੱਖ-ਰਖਾਅ", "bn": "বনাচ্ছাদন রক্ষণাবেক্ষণ",
    },
    "Organic Carbon Build-up": {
      "en": "Organic Carbon Build-up", "hi": "जैविक कार्बन निर्माण", "ta": "கரிம கார்பன் சேர்த்தல்",
      "te": "సేంద్రీయ కార్బన్ నిర్మాణం", "kn": "ಸಾವಯವ ಇಂಗಾಲ ಹೆಚ್ಚಳ", "ml": "ജൈവ കാർബൺ ശേഖരണം",
      "mr": "सेंद्रिय कार्बन वाढवणे", "gu": "Organic Carbon Build-up", "pa": "ਜੈਵਿਕ ਕਾਰਬਨ ਵਧਾਉਣਾ", "bn": "জৈব কার্বন বৃদ্ধি",
    },
    "Leaching — Essential First Step": {
      "en": "Leaching — Essential First Step", "hi": "लीचिंग — आवश्यक पहला कदम",
      "ta": "வடிகசிவு — அவசியமான முதல் படி", "te": "లీచింగ్ — అవసరమైన మొదటి దశ",
      "kn": "ಲೀಚಿಂಗ್ — ಅಗತ್ಯ ಮೊದಲ ಹೆಜ್ಜೆ", "ml": "ലീച്ചിങ് — ആദ്യ ഘട്ടം",
      "mr": "लिचिंग — आवश्यक पहिली पायरी", "gu": "Leaching — Essential First Step", "pa": "ਲੀਚਿੰਗ — ਜ਼ਰੂਰੀ ਪਹਿਲਾ ਕਦਮ", "bn": "লিচিং — প্রয়োজনীয় প্রথম পদক্ষেপ",
    },
    "Salt-Tolerant Crop Sequence": {
      "en": "Salt-Tolerant Crop Sequence", "hi": "लवण-सहिष्णु फसल क्रम",
      "ta": "உப்பு-தாங்கும் பயிர் வரிசை", "te": "ఉప్పు-తట్టుకునే పంట క్రమం",
      "kn": "ಉಪ್ಪು-ಸಹಿಷ್ಣು ಬೆಳೆ ಅನುಕ್ರಮ", "ml": "ഉപ്പ്-സഹിഷ്ണു വിള ക്രമം",
      "mr": "क्षार-सहिष्णु पीक क्रम", "gu": "Salt-Tolerant Crop Sequence", "pa": "ਲੂਣ-ਸਹਿਣਸ਼ੀਲ ਫ਼ਸਲ ਕ੍ਰਮ", "bn": "লবণ-সহনশীল ফসল ক্রম",
    },
    "Irrigation Management": {
      "en": "Irrigation Management", "hi": "सिंचाई प्रबंधन", "ta": "நீர்ப்பாசன மேலாண்மை",
      "te": "సాగునీటి నిర్వహణ", "kn": "ನೀರಾವರಿ ನಿರ್ವಹಣೆ", "ml": "ജലസേചന മാനേജ്മെന്റ്",
      "mr": "सिंचन व्यवस्थापन", "gu": "Irrigation Management", "pa": "ਸਿੰਚਾਈ ਪ੍ਰਬੰਧਨ", "bn": "সেচ ব্যবস্থাপনা",
    },
    "Long-term pH Correction": {
      "en": "Long-term pH Correction", "hi": "दीर्घकालीन pH सुधार", "ta": "நீண்ட கால pH திருத்தம்",
      "te": "దీర్ఘకాలిక pH దిద్దుబాటు", "kn": "ದೀರ್ಘಾವಧಿ pH ಸರಿಪಡಿಸುವಿಕೆ", "ml": "ദീർഘകാല pH തിരുത്തൽ",
      "mr": "दीर्घकालीन pH सुधारणा", "gu": "Long-term pH Correction", "pa": "ਲੰਬੇ ਸਮੇਂ ਦਾ pH ਸੁਧਾਰ", "bn": "দীর্ঘমেয়াদী pH সংশোধন",
    },
    "General Amendment": {
      "en": "General Amendment", "hi": "सामान्य सुधार", "ta": "பொது திருத்தம்",
      "te": "సాధారణ సంశోధన", "kn": "ಸಾಮಾನ್ಯ ತಿದ್ದುಪಡಿ", "ml": "പൊതു ഭേദഗതി",
      "mr": "सामान्य दुरुस्ती", "gu": "સામाন्य सुधारो", "pa": "ਆਮ ਸੁਧਾਰ", "bn": "সাধারণ সংশোধন",
    },
  };

  static String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?["en"] ?? key;

  // ── Value translations ──────────────────────────────────────────────────
  // For compactness, values are stored per soil type in a nested map.
  // Keys match the English label key.

  static Map<String, Map<String, Map<String, String>>> _values() => {

    // ════════════════════════════════════════════
    // ALLUVIAL SOIL
    // ════════════════════════════════════════════
    "Alluvial Soil": {
      "Primary NPK_fert": {
        "en": "Apply a balanced NPK (120:60:40 kg/ha) at sowing. Nitrogen is the most limiting nutrient — split into 2–3 doses to reduce leaching losses from these well-draining soils.",
        "hi": "बुवाई पर संतुलित NPK (120:60:40 किग्रा/हेक्टेयर) डालें। नाइट्रोजन सबसे सीमित पोषक है — रिसाव हानि कम करने के लिए 2–3 खुराकों में बांटें।",
        "ta": "விதைப்பு நேரத்தில் சம NPK (120:60:40 கிகி/ஹெக்.) இடுங்கள். நைட்ரஜன் மிக முக்கிய பற்றாக்குறை — 2–3 தவணைகளில் கொடுங்கள்.",
        "te": "విత్తనాల సమయంలో సమతుల్య NPK (120:60:40 కిలో/హె.) వేయండి. నైట్రోజన్ అత్యంత పరిమిత పోషకం — 2–3 విడతలుగా వేయండి.",
        "kn": "ಬಿತ್ತನೆ ಸಮಯ ಸಮತೋಲ NPK (120:60:40 ಕಿ/ಹೆ.) ಹಾಕಿ. ನೈಟ್ರೋಜನ್ ಅತ್ಯಂತ ಕೊರತೆಯ ಪೋಷಕ — 2–3 ಕಂತುಗಳಲ್ಲಿ ನೀಡಿ.",
        "ml": "വിത്ത് ഇടുന്ന സമയം NPK (120:60:40 കി.ഗ്ര/ഹെ.) ഇടുക. നൈട്രജൻ ഏറ്റവും പരിമിത പോഷകം — 2–3 ഡോസ് ആയി നൽകുക.",
        "mr": "पेरणीच्या वेळी संतुलित NPK (120:60:40 किग्रा/हे.) द्या. नायट्रोजन सर्वाधिक मर्यादित पोषक — 2–3 हप्त्यांत द्या.",
        "gu": "વાવણી સમyе NPK (120:60:40 કિ/હે.) આपો. N सौથी मर्यादित — 2–3 ডোзে आпо.",
        "pa": "ਬਿਜਾਈ ਸਮੇਂ NPK (120:60:40 ਕਿ/ਹੈ.) ਪਾਓ। N ਸਭ ਤੋਂ ਸੀਮਤ — 2–3 ਖੁਰਾਕਾਂ ਵਿੱਚ ਦਿਓ।",
        "bn": "বপনের সময় NPK (120:60:40 কেজি/হে.) দিন। N সবচেয়ে সীমিত — 2–3 ভাগে দিন।",
      },
      "Nitrogen Source_fert": {
        "en": "Urea (46% N) is the most common and cost-effective source. Apply 1/3 as basal dose and the rest as top-dressing at 30 and 60 days after sowing (DAS).",
        "hi": "यूरिया (46% N) सबसे सामान्य और किफायती स्रोत है। 1/3 बेसल खुराक के रूप में और बाकी 30 व 60 DAS पर टॉप-ड्रेसिंग करें।",
        "ta": "யூரியா (46% N) மிகவும் பொதுவான மூலம். 1/3 அடிவேர் அளவாகவும் மீதமுள்ளதை 30 மற்றும் 60 DAS-ல் தெளிக்கவும்.",
        "te": "యూరియా (46% N) అత్యంత సాధారణ మూలం. 1/3 బేసల్ మోతాదుగా మిగతాది 30 & 60 DAS-లో టాప్-డ్రెస్ చేయండి.",
        "kn": "ಯೂರಿಯಾ (46% N) ಸಾಮಾನ್ಯ ಮೂಲ. 1/3 ಮೂಲ ಡೋಸ್, ಉಳಿದದ್ದು 30 ಮತ್ತು 60 DAS ನಲ್ಲಿ ಹಾಕಿ.",
        "ml": "യൂറിയ (46% N) ഏറ്റവും സാധാരണ സ്രോതസ്സ്. 1/3 ബേസൽ ഡോസ്, ബാക്കി 30 & 60 DAS-ൽ ടോപ്-ഡ്രസ്സ് ചെയ്യുക.",
        "mr": "युरिया (46% N) सर्वात सामान्य. 1/3 मूळ डोस, बाकी 30 व 60 DAS वर टॉप-ड्रेसिंग.",
        "gu": "Urea (46% N) સૌथी सामान्य. 1/3 basal, बाकी 30 व 60 DAS পর टॉप-ड्रेস।",
        "pa": "ਯੂਰੀਆ (46% N) ਸਭ ਤੋਂ ਆਮ। 1/3 ਬੇਸਲ, ਬਾਕੀ 30 ਤੇ 60 DAS ਤੇ।",
        "bn": "ইউরিয়া (46% N) সবচেয়ে সাধারণ। 1/3 বেসাল, বাকি 30 ও 60 DAS-এ দিন।",
      },
      "Organic Supplement_fert": {
        "en": "Apply 10–15 t/ha of FYM or vermicompost (2.5 t/ha) before sowing. Combining 75% chemical NPK + vermicompost has shown superior yield over full chemical input alone in West Bengal trials.",
        "hi": "बुवाई से पहले 10–15 टन/हेक्टेयर FYM या केंचुआ खाद (2.5 टन/हेक्टेयर) डालें।",
        "ta": "விதைப்புக்கு முன் 10–15 டன்/ஹெக். FYM அல்லது மண்புழு உரம் இடுங்கள்.",
        "te": "విత్తనాలు వేయడానికి ముందు 10–15 t/ha FYM లేదా వర్మీకంపోస్ట్ వేయండి.",
        "kn": "ಬಿತ್ತನೆ ಮೊದಲು 10–15 t/ha FYM ಅಥವಾ ವರ್ಮಿಕಂಪೋಸ್ಟ್ ಹಾಕಿ.",
        "ml": "വിത്ത് ഇടുന്നതിന് മുൻപ് 10–15 t/ha FYM അഥവാ വേർമിക്കംപോസ്റ്റ് ഇടുക.",
        "mr": "पेरणीपूर्वी 10–15 t/ha FYM किंवा गांडूळ खत द्या.",
        "gu": "વāвणī पहेला 10–15 t/ha FYM या वर्मीकंपोस्ट नाखो.",
        "pa": "ਬਿਜਾਈ ਤੋਂ ਪਹਿਲਾਂ 10–15 ਟਨ/ਹੈ. FYM ਜਾਂ ਕੀੜੇ ਖਾਦ ਪਾਓ।",
        "bn": "বপনের আগে 10–15 t/ha FYM বা ভার্মিকম্পোস্ট দিন।",
      },
      "Biofertilizers_fert": {
        "en": "Seed treatment with Azotobacter + PSB (Phosphate Solubilizing Bacteria) can save 20–25% chemical nitrogen. Particularly effective in older alluvial (bhangar) soils.",
        "hi": "Azotobacter + PSB से बीज उपचार 20–25% रासायनिक नाइट्रोजन बचा सकता है।",
        "ta": "Azotobacter + PSB விதை சிகிச்சை 20–25% ரசாயன நைட்ரஜன் மிச்சப்படுத்தும்.",
        "te": "Azotobacter + PSB విత్తన శుద్ధి 20–25% రసాయన నైట్రోజన్ ఆదా చేయగలదు.",
        "kn": "Azotobacter + PSB ಬೀಜ ಸಂಸ್ಕರಣ 20–25% ರಾಸಾಯನಿಕ ನೈಟ್ರೋಜನ್ ಉಳಿಸುತ್ತದೆ.",
        "ml": "Azotobacter + PSB ബീജ ചികിത്സ 20–25% N ലാഭിക്കും.",
        "mr": "Azotobacter + PSB बीज प्रक्रिया 20–25% रासायनिक N वाचवू शकते.",
        "gu": "Azotobacter + PSB बीज उपचार 20–25% N बचावे.",
        "pa": "Azotobacter + PSB ਬੀਜ ਇਲਾਜ 20–25% N ਬਚਾਉਂਦਾ ਹੈ।",
        "bn": "Azotobacter + PSB বীজ চিকিৎসা 20–25% N বাঁচায়।",
      },
      "Watch For_fert": {
        "en": "Zinc (Zn) deficiency is widespread — apply ZnSO₄ at 25 kg/ha once every 3 years. Sulphur deficiency is increasing; use Single Superphosphate (SSP) instead of DAP where possible.",
        "hi": "जिंक की कमी व्यापक — हर 3 साल में ZnSO₄ 25 किग्रा/हेक्टेयर डालें।",
        "ta": "துத்தநாக குறைபாடு பரவலாக உள்ளது — 3 ஆண்டுகளுக்கு ஒரு முறை ZnSO₄ 25 கிகி/ஹெக். இடுங்கள்.",
        "te": "జింక్ లోపం విస్తారంగా ఉంది — ప్రతి 3 సంవత్సరాలకు ZnSO₄ 25 kg/ha వేయండి.",
        "kn": "ಜಿಂಕ್ ಕೊರತೆ ವ್ಯಾಪಕ — ಪ್ರತಿ 3 ವರ್ಷಕ್ಕೊಮ್ಮೆ ZnSO₄ 25 kg/ha ಹಾಕಿ.",
        "ml": "സിങ്ക് കുറവ് വ്യാപകം — 3 വർഷം ഒരിക്കൽ ZnSO₄ 25 kg/ha ഇടുക.",
        "mr": "Zinc कमतरता व्यापक — दर 3 वर्षांनी ZnSO₄ 25 kg/ha द्या.",
        "gu": "Zinc ни ऊणप व्यापक — दर 3 वर्षे ZnSO₄ 25 kg/ha नाखо.",
        "pa": "Zinc ਦੀ ਕਮੀ ਆਮ — ਹਰ 3 ਸਾਲ ZnSO₄ 25 kg/ha ਪਾਓ।",
        "bn": "Zinc এর ঘাটতি বিস্তৃত — প্রতি 3 বছর ZnSO₄ 25 kg/ha দিন।",
      },
      "Crop Rotation_amend": {
        "en": "Rice–Wheat is the dominant rotation in Indo-Gangetic Plains. Introduce a legume (green gram, lentil) every 3rd year to fix atmospheric nitrogen and break pest cycles.",
        "hi": "इंडो-गैंगेटिक मैदानों में धान–गेहूँ प्रमुख चक्र है। हर 3 साल में दलहन (मूंग, मसूर) डालें।",
        "ta": "இந்தோ-கங்கை சமவெளியில் நெல்–கோதுமை முக்கிய சுழற்சி. 3ஆம் ஆண்டு பருப்பு சேர்க்கவும்.",
        "te": "ఇండో-గంగా మైదానంలో వరి–గోధుమ ప్రధాన మార్పిడి. ప్రతి 3 సంవత్సరాలకు పప్పు చేర్చండి.",
        "kn": "ಇಂಡೋ-ಗಂಗಾ ಬಯಲಿನಲ್ಲಿ ಭತ್ತ–ಗೋಧಿ ಮುಖ್ಯ ಪರಿವರ್ತನೆ. 3ನೇ ವರ್ಷ ದ್ವಿದಳ ಸೇರಿಸಿ.",
        "ml": "ഇൻഡോ-ഗംഗ സമതലത്തിൽ നെൽ–ഗോതമ്പ് പ്രധാന ഭ്രമണം. ഓരോ 3 വർഷം ഒരു പയർ ചേർക്കുക.",
        "mr": "इंडो-गंगेत्तर मैदानात भात–गहू मुख्य फेरबदल. 3र्‍या वर्षी कडधान्य घाला.",
        "gu": "Indo-Gangetic मेदान में धान–गेहूं मुख्य चक्र. 3जे वर्षे कलाय ઉমेरो.",
        "pa": "ਇੰਡੋ-ਗੰਗਾ ਮੈਦਾਨ ਵਿੱਚ ਝੋਨਾ–ਕਣਕ ਮੁੱਖ। ਹਰ 3 ਸਾਲ ਦਾਲ ਸ਼ਾਮਲ ਕਰੋ।",
        "bn": "ইন্দো-গঙ্গা সমভূমিতে ধান–গম প্রধান চক্র। প্রতি 3 বছর ডাল যোগ করুন।",
      },
      "Green Manuring_amend": {
        "en": "Incorporate Sesbania aculeata (dhaincha) or sunhemp at 45 days of growth before transplanting rice — adds 80–100 kg N/ha organically and improves soil structure.",
        "hi": "धान रोपाई से पहले 45 दिन की ढैंचा या सनई को मिट्टी में मिलाएं — 80–100 किग्रा N/हे. जोड़ता है।",
        "ta": "நெல் நடவுக்கு முன் 45 நாள் வளர்ந்த தைஞ்சை அல்லது சணப்பை மண்ணில் கலக்கவும்.",
        "te": "వరి నాటడానికి ముందు 45 రోజుల దైంచా లేదా సన్‌హెంప్ నేలలో కలపండి.",
        "kn": "ಭತ್ತ ನಾಟಿ ಮೊದಲು 45 ದಿನ ಬೆಳೆದ ಢೈಂಚಾ ಅಥವಾ ಸನ್‌ಹೆಂಪ್ ಮಣ್ಣಿಗೆ ಸೇರಿಸಿ.",
        "ml": "നെൽ ഞാറ് നടുന്നതിന് മുൻ 45 ദിവസ ഢൈൻചാ മണ്ണിൽ ഉൾക്കൊള്ളിക്കുക.",
        "mr": "भात लावणीपूर्वी 45 दिवस वाढलेली ढैंचा मातीत मिसळा.",
        "gu": "ধান रोपण पहेला 45 দিন ढेंचा मिट्टी में मेलवो.",
        "pa": "ਝੋਨਾ ਲਾਉਣ ਤੋਂ ਪਹਿਲਾਂ 45 ਦਿਨ ਦਾ ਢੈਂਚਾ ਮਿੱਟੀ ਵਿੱਚ ਮਿਲਾਓ।",
        "bn": "ধান লাগানোর আগে 45 দিনের ঢেঞ্চা মাটিতে মিশিয়ে দিন।",
      },
      "Irrigation Practice_amend": {
        "en": "Alluvial soils respond excellently to canal and tube-well irrigation. Use furrow or flood irrigation for cereals; drip irrigation for vegetables improves water-use efficiency by 30–40%.",
        "hi": "जलोढ़ मिट्टी नहर और ट्यूबवेल सिंचाई पर उत्कृष्ट प्रतिक्रिया देती है। अनाज के लिए फरो/बाढ़ सिंचाई; सब्जियों के लिए ड्रिप।",
        "ta": "கால்வாய் மற்றும் குழாய் நீரில் நல்ல விளைவு. தானியங்களுக்கு வாய்க்கால் நீர்; காய்கறிகளுக்கு துளி நீர்.",
        "te": "కాలువ నీటిపారుదలకు చక్కగా స్పందిస్తుంది. ధాన్యాలకు ఫర్రో; కూరగాయలకు డ్రిప్.",
        "kn": "ಕಾಲುವೆ ನೀರಾವರಿಗೆ ಉತ್ತಮ. ಧಾನ್ಯಕ್ಕೆ ಮೂಗು; ತರಕಾರಿಗೆ ಡ್ರಿಪ್.",
        "ml": "കനാൽ ജലസേചനത്തിന് ഉത്തമ. ധാന്യത്തിന് ഫർറോ; പച്ചക്കറിക്ക് ഡ്രിപ്.",
        "mr": "नहर सिंचनास उत्तम प्रतिसाद. धान्यासाठी सरी; भाज्यांसाठी ठिबक.",
        "gu": "नहेर सिंचाईને ઉत्तम. अनाज माटे furrow; शाकभाजी माटे drip.",
        "pa": "ਨਹਿਰੀ ਸਿੰਚਾਈ ਵਧੀਆ। ਅਨਾਜ ਲਈ ਫਰੋ; ਸਬਜ਼ੀਆਂ ਲਈ ਡ੍ਰਿੱਪ।",
        "bn": "খাল ও নলকূপ সেচে উৎকৃষ্ট। শস্যে ফারো; সবজিতে ড্রিপ।",
      },
      "Organic Matter_amend": {
        "en": "Annual compost addition is essential — continuous cultivation depletes organic carbon rapidly. Target soil organic carbon (SOC) above 0.5%. Mulching with crop residues reduces evaporation.",
        "hi": "वार्षिक खाद जरूरी — लगातार खेती जैविक कार्बन तेजी से घटाती है। SOC 0.5% से ऊपर रखें।",
        "ta": "ஆண்டுதோறும் உரம் அவசியம். SOC 0.5%க்கு மேல் இருக்கட்டும். வைக்கோல் மூடு போடுங்கள்.",
        "te": "వార్షిక కంపోస్ట్ అవసరం. SOC 0.5% కంటే పైన ఉంచండి. మల్చింగ్ చేయండి.",
        "kn": "ವಾರ್ಷಿಕ ಕಂಪೋಸ್ಟ್ ಅಗತ್ಯ. SOC 0.5% ಮೇಲಿರಲಿ. ಮಲ್ಚಿಂಗ್ ಮಾಡಿ.",
        "ml": "വാർഷിക കംപോസ്റ്റ് അനിവാര്യം. SOC 0.5% ൽ കൂടുതൽ. മൾചിങ് ചെയ്യുക.",
        "mr": "वार्षिक कंपोस्ट आवश्यक. SOC 0.5% वर ठेवा. आच्छादन करा.",
        "gu": "वार्षिक खाद जरूरी. SOC 0.5% ऊपर. Mulching करो.",
        "pa": "ਸਾਲਾਨਾ ਖਾਦ ਜ਼ਰੂਰੀ। SOC 0.5% ਤੋਂ ਉੱਪਰ। Mulching ਕਰੋ।",
        "bn": "বার্ষিক কম্পোস্ট আবশ্যক। SOC 0.5% এর উপরে। মালচিং করুন।",
      },
    },

    // ════════════════════════════════════════════
    // RED SOIL — abridged for other soils;
    // pattern is identical, values translated similarly
    // ════════════════════════════════════════════
    "Red Soil": {
      "Primary NPK_fert": {
        "en": "Red soils are deficient in N, P, and humus. Apply nitrogen-heavy NPK (80:40:40 kg/ha for millets; 60:30:30 for pulses). Phosphorus is especially critical — use DAP (18:46:0) as basal dose.",
        "hi": "लाल मिट्टी में N, P और ह्यूमस की कमी है। NPK (80:40:40 किग्रा/हे. मिलेट; 60:30:30 दालों के लिए) डालें।",
        "ta": "சிவப்பு மண்ணில் N, P, ஹியூமஸ் குறைவு. NPK (80:40:40 தினை; 60:30:30 பருப்பு) இடுங்கள்.",
        "te": "ఎర్ర నేలలో N, P, హ్యూమస్ తక్కువ. NPK (80:40:40 రాగులకు; 60:30:30 పప్పులకు) వేయండి.",
        "kn": "ಕೆಂಪು ಮಣ್ಣಿನಲ್ಲಿ N, P, ಹ್ಯೂಮಸ್ ಕೊರತೆ. NPK (80:40:40 ಕಿ/ಹೆ.) ಹಾಕಿ.",
        "ml": "ചുവന്ന മണ്ണ് N, P, ഹ്യൂമസ് കുറവ്. NPK (80:40:40) ഇടുക.",
        "mr": "लाल मातीत N, P, बुरशी कमी. NPK (80:40:40 किग्रा/हे.) द्या.",
        "gu": "लाल माटी N, P, humus माँ ऊणप. NPK (80:40:40) नाखो.",
        "pa": "ਲਾਲ ਮਿੱਟੀ ਵਿੱਚ N, P, humus ਘੱਟ। NPK (80:40:40) ਪਾਓ।",
        "bn": "লাল মাটিতে N, P, হিউমাস কম। NPK (80:40:40) দিন।",
      },
      "Lime to Correct Acidity_fert": {
        "en": "pH typically 5.5–7.0. For red soils below pH 6.0, apply agricultural lime at 1–2 t/ha to neutralise acidity and unlock phosphorus. Apply 3–4 weeks before sowing.",
        "hi": "pH 5.5–7.0। pH 6.0 से नीचे पर 1–2 टन/हेक्टेयर कृषि चूना डालें।",
        "ta": "pH 5.5–7.0. pH 6.0 க்கு கீழிருந்தால் 1–2 t/ha சுண்ணாம்பு போடுங்கள்.",
        "te": "pH 5.5–7.0. pH 6.0 దిగువ ఉంటే 1–2 t/ha సుద్ద వేయండి.",
        "kn": "pH 5.5–7.0. pH 6.0 ಕೆಳಗಿದ್ದರೆ 1–2 t/ha ಸುಣ್ಣ ಹಾಕಿ.",
        "ml": "pH 5.5–7.0. pH 6.0 ൽ കുറഞ്ഞാൽ 1–2 t/ha ചുണ്ണാമ്പ് ഇടുക.",
        "mr": "pH 5.5–7.0. pH 6.0 खाली असल्यास 1–2 t/ha चुना द्या.",
        "gu": "pH 5.5–7.0. pH 6.0 नीचे होय तो 1–2 t/ha चूनो नाखो.",
        "pa": "pH 5.5–7.0. pH 6.0 ਤੋਂ ਘੱਟ ਹੋਵੇ ਤਾਂ 1–2 t/ha ਚੂਨਾ ਪਾਓ।",
        "bn": "pH 5.5–7.0। pH 6.0 এর নিচে হলে 1–2 t/ha চুন দিন।",
      },
      "Organic Manure_fert": {
        "en": "Heavy FYM application (15–20 t/ha) is especially valuable — red soils are naturally very low in organic matter. Groundnut shell compost and neem cake (200 kg/ha) are excellent local alternatives.",
        "hi": "FYM (15–20 टन/हे.) विशेष रूप से मूल्यवान। मूँगफली छिलका खाद और नीम केक स्थानीय विकल्प।",
        "ta": "FYM (15–20 t/ha) மிகவும் பயனுள்ளது. நிலக்கடலை ஓடு உரம் நல்ல மாற்று.",
        "te": "FYM (15–20 t/ha) చాలా విలువైనది. వేరుశెనగ పొట్టు కంపోస్ట్ స్థానిక ప్రత్యామ్నాయం.",
        "kn": "FYM (15–20 t/ha) ವಿಶೇಷ. ಕಡಲೆ ಚಿಪ್ಪು ಗೊಬ್ಬರ ಸ್ಥಳೀಯ ಆಯ್ಕೆ.",
        "ml": "FYM (15–20 t/ha) വളരെ മൂല്യവത്ത്. നിലക്കടല തൊണ്ട് കംപോസ്റ്റ്.",
        "mr": "FYM (15–20 t/ha) विशेष उपयुक्त. शेंगदाणा टरफले कंपोस्ट.",
        "gu": "FYM (15–20 t/ha) ખૂব ઉपयोगी. مونगفळी छाल खाद.",
        "pa": "FYM (15–20 t/ha) ਬਹੁਤ ਕੀਮਤੀ। ਮੂੰਗਫਲੀ ਛਿਲਕਾ ਖਾਦ।",
        "bn": "FYM (15–20 t/ha) বিশেষ। চিনাবাদামের খোসা সার।",
      },
      "Micronutrients_fert": {
        "en": "Boron (B) and iron (Fe) deficiencies are common. Apply borax at 1 kg/ha for groundnut and pulses. Iron chelate foliar sprays correct chlorosis in young plants quickly.",
        "hi": "बोरोन और आयरन की कमी आम। मूँगफली और दालों के लिए बोरेक्स 1 किग्रा/हे.।",
        "ta": "B மற்றும் Fe குறைபாடு பொதுவானது. 1 kg/ha borax போடுங்கள்.",
        "te": "B మరియు Fe లోపం సాధారణం. Borax 1 kg/ha వేయండి.",
        "kn": "B ಮತ್ತು Fe ಕೊರತೆ ಸಾಮಾನ್ಯ. ಬೋರಾಕ್ಸ್ 1 kg/ha ಹಾಕಿ.",
        "ml": "B & Fe കുറവ് സാധാരണം. ബോറാക്സ് 1 kg/ha ഇടുക.",
        "mr": "B आणि Fe कमतरता सामान्य. Borax 1 kg/ha द्या.",
        "gu": "B & Fe ऊणप. Borax 1 kg/ha नाखो.",
        "pa": "B ਤੇ Fe ਕਮੀ ਆਮ। Borax 1 kg/ha ਪਾਓ।",
        "bn": "B ও Fe এর ঘাটতি সাধারণ। Borax 1 kg/ha দিন।",
      },
      "Watch For_fert": {
        "en": "Avoid heavy irrigation — fine-grained red soils crust easily on the surface, blocking seedling emergence. Mulching immediately after sowing prevents surface crust formation.",
        "hi": "भारी सिंचाई से बचें — बारीक लाल मिट्टी की सतह सख्त हो जाती है।",
        "ta": "அதிக நீர் தவிர்க்கவும் — மேற்பரப்பு கெட்டியாகும். விதைப்புக்கு பின் மூடு போடுங்கள்.",
        "te": "అధిక నీటిపారుదల నివారించండి — ఎర్ర నేల పైపొర గట్టిపడుతుంది.",
        "kn": "ಹೆಚ್ಚು ನೀರು ತಡೆ — ಕೆಂಪು ಮಣ್ಣು ಮೇಲ್ಪದರ ಗಟ್ಟಿಯಾಗುತ್ತದೆ.",
        "ml": "അധിക ജലം ഒഴിവാക്കുക — ചുവന്ന മണ്ണ് ഉപരിതലം ദൃഢമാകും.",
        "mr": "अधिक सिंचन टाळा — लाल माती पृष्ठभाग कडक होतो.",
        "gu": "ਹੇਵੀ ਸਿੰਚਾਈ ਤੋਂ ਬਚੋ।",
        "pa": "ਭਾਰੀ ਸਿੰਚਾਈ ਤੋਂ ਬਚੋ।",
        "bn": "অতিরিক্ত সেচ এড়ান।",
      },
      "Crop Rotation_amend": {
        "en": "Groundnut–sorghum or millets–pulses rotation works best. Groundnut fixes nitrogen and leaves residues that improve the organic content of this naturally low-humus soil.",
        "hi": "मूँगफली–ज्वार या मिलेट–दाल चक्र सबसे उपयुक्त।",
        "ta": "நிலக்கடலை–சோளம் அல்லது தினை–பருப்பு சுழற்சி சிறந்தது.",
        "te": "వేరుశెనగ–జొన్న లేదా రాగి–పప్పు మార్పిడి ఉత్తమం.",
        "kn": "ಕಡಲೆ–ಜೋಳ ಅಥವಾ ಧಾನ್ಯ–ದ್ವಿದಳ ಪರಿವರ್ತನೆ ಉತ್ತಮ.",
        "ml": "നിലക്കടല–ജോവ്വർ ഭ്രമണം ഉത്തമം.",
        "mr": "शेंगदाणा–ज्वारी किंवा तृणधान्य–कडधान्य फेरबदल.",
        "gu": "Groundnut–jowar rotation ઉत্তম.",
        "pa": "ਮੂੰਗਫਲੀ–ਜਵਾਰ ਜਾਂ ਮਿਲੇਟ–ਦਾਲ ਚੱਕਰ।",
        "bn": "চিনাবাদাম–জোয়ার বা মিলেট–ডাল আবর্তন।",
      },
      "Green Manuring_amend": {
        "en": "Incorporate Crotalaria juncea (sunhemp) or cowpea green manure before the main crop to add 40–60 kg N/ha.",
        "hi": "मुख्य फसल से पहले सनई या लोबिया हरी खाद मिलाएं।",
        "ta": "முக்கிய பயிருக்கு முன் சணப்பை கலக்கவும்.",
        "te": "ప్రధాన పంటకు ముందు సన్‌హెంప్ కలపండి.",
        "kn": "ಮುಖ್ಯ ಬೆಳೆ ಮೊದಲು ಸನ್‌ಹೆಂಪ್ ಸೇರಿಸಿ.",
        "ml": "പ്രധാന വിളക്ക് മുൻ സൻഹെംപ് ഉൾക്കൊള്ളിക്കുക.",
        "mr": "मुख्य पिकाआधी सनई समाविष्ट करा.",
        "gu": "मुख्य पाकना पहेला Sunhemp मेलवो.",
        "pa": "ਮੁੱਖ ਫਸਲ ਤੋਂ ਪਹਿਲਾਂ ਸਨਹੈਂਪ ਮਿਲਾਓ।",
        "bn": "মূল ফসলের আগে সানহেম্প মেশান।",
      },
      "Water Conservation_amend": {
        "en": "Red soils drain very quickly — construct farm ponds and contour bunds to retain runoff. Drip or sprinkler irrigation is recommended over flood irrigation.",
        "hi": "लाल मिट्टी बहुत जल्दी सूखती है — तालाब और समोच्च बंध बनाएं।",
        "ta": "சிவப்பு மண் வேகமாக வடிகிறது — குளம் மற்றும் கட்டுக்கள் கட்டுங்கள்.",
        "te": "ఎర్ర నేల వేగంగా నీరు వదిలిస్తుంది — చెరువులు నిర్మించండి.",
        "kn": "ಕೆಂಪು ಮಣ್ಣು ತ್ವರಿತ ಒಳಗೆ ಹೋಗುತ್ತದೆ — ಕೊಳ ಮತ್ತು ಬಂಡ್ ನಿರ್ಮಿಸಿ.",
        "ml": "ചുവന്ന മണ്ണ് വേഗം ഒഴുകുന്നു — കുളം നിർമ്മിക്കുക.",
        "mr": "लाल माती लवकर निचऱ्या — तलाव व बांध बांधा.",
        "gu": "लाल माटी ઝडپी निकले — तलाव बनावो.",
        "pa": "ਲਾਲ ਮਿੱਟੀ ਜਲਦੀ ਸੁੱਕਦੀ ਹੈ — ਤਲਾਅ ਬਣਾਓ।",
        "bn": "লাল মাটি দ্রুত শুকায় — পুকুর ও বাঁধ তৈরি করুন।",
      },
      "Soil Structure_amend": {
        "en": "Annual organic matter addition is critical. Sandy-loam red soils benefit from cocopeat or rice husk ash. Avoid tilling when wet — surface sealing destroys tilth rapidly.",
        "hi": "वार्षिक जैविक पदार्थ जरूरी। नारियल पीट या चावल की भूसी राख।",
        "ta": "கரிமப் பொருள் ஆண்டுதோறும் சேர்க்கவும். Cocopeat அல்லது நெல் தவிட்டு சாம்பல்.",
        "te": "వార్షిక సేంద్రీయ పదార్థం అవసరం. కోకోపీట్ లేదా అక్కి తొక్కు బూడిద.",
        "kn": "ವಾರ್ಷಿಕ ಸಾವಯವ ವಸ್ತು ಅಗತ್ಯ. ಕೋಕೋಪೀಟ್ ಅಥವಾ ಅಕ್ಕಿ ಹೊಟ್ಟು ಬೂದಿ.",
        "ml": "വാർഷിക ജൈവ പദാർഥം അനിവാര്യം. കോകോ പീറ്റ്.",
        "mr": "वार्षिक सेंद्रिय घटक आवश्यक. कोकोपीट वापरा.",
        "gu": "ਵार्षिक organic पदार्थ जरूरी. Cocopeat वापरो.",
        "pa": "ਸਾਲਾਨਾ ਜੈਵਿਕ ਪਦਾਰਥ ਜ਼ਰੂਰੀ। Cocopeat ਵਰਤੋ।",
        "bn": "বার্ষিক জৈব পদার্থ দরকার। Cocopeat ব্যবহার করুন।",
      },
    },
  };

  // ── Public API ──────────────────────────────────────────────────────────

  static Map<String, List<Map<String, String>>> forSoil(
      String soilType, String lang) {

    // Helper to get translated value with English fallback
    String val(String soil, String key) {
      return _values()[soil]?[key]?[lang]
          ?? _values()[soil]?[key]?["en"]
          ?? "";
    }

    String lbl(String key) => _label(key, lang);

    switch (soilType) {

      case "Alluvial Soil":
        return {
          "fertRows": [
            {"icon": "science",    "label": lbl("Primary NPK"),         "value": val("Alluvial Soil","Primary NPK_fert")},
            {"icon": "add_circle", "label": lbl("Nitrogen Source"),     "value": val("Alluvial Soil","Nitrogen Source_fert")},
            {"icon": "eco",        "label": lbl("Organic Supplement"),  "value": val("Alluvial Soil","Organic Supplement_fert")},
            {"icon": "biotech",    "label": lbl("Biofertilizers"),      "value": val("Alluvial Soil","Biofertilizers_fert")},
            {"icon": "warning",    "label": lbl("Watch For"),           "value": val("Alluvial Soil","Watch For_fert")},
          ],
          "amendRows": [
            {"icon": "loop",    "label": lbl("Crop Rotation"),       "value": val("Alluvial Soil","Crop Rotation_amend")},
            {"icon": "grass",   "label": lbl("Green Manuring"),      "value": val("Alluvial Soil","Green Manuring_amend")},
            {"icon": "water",   "label": lbl("Irrigation Practice"), "value": val("Alluvial Soil","Irrigation Practice_amend")},
            {"icon": "healing", "label": lbl("Organic Matter"),      "value": val("Alluvial Soil","Organic Matter_amend")},
          ],
        };

      case "Red Soil":
        return {
          "fertRows": [
            {"icon": "science",    "label": lbl("Primary NPK"),              "value": val("Red Soil","Primary NPK_fert")},
            {"icon": "add_circle", "label": lbl("Lime to Correct Acidity"), "value": val("Red Soil","Lime to Correct Acidity_fert")},
            {"icon": "eco",        "label": lbl("Organic Manure"),           "value": val("Red Soil","Organic Manure_fert")},
            {"icon": "biotech",    "label": lbl("Micronutrients"),           "value": val("Red Soil","Micronutrients_fert")},
            {"icon": "warning",    "label": lbl("Watch For"),                "value": val("Red Soil","Watch For_fert")},
          ],
          "amendRows": [
            {"icon": "loop",    "label": lbl("Crop Rotation"),     "value": val("Red Soil","Crop Rotation_amend")},
            {"icon": "grass",   "label": lbl("Green Manuring"),    "value": val("Red Soil","Green Manuring_amend")},
            {"icon": "water",   "label": lbl("Water Conservation"),"value": val("Red Soil","Water Conservation_amend")},
            {"icon": "healing", "label": lbl("Soil Structure"),    "value": val("Red Soil","Soil Structure_amend")},
          ],
        };

      // For remaining soils, English values are used as the full translation
      // infrastructure is identical — add translated _values entries to extend.
      case "Black Soil (Regur)":
        return _englishFallback(_blackSoilEn(), lang, lbl);
      case "Laterite Soil":
        return _englishFallback(_lateriteSoilEn(), lang, lbl);
      case "Desert Soil":
        return _englishFallback(_desertSoilEn(), lang, lbl);
      case "Mountain Soil":
        return _englishFallback(_mountainSoilEn(), lang, lbl);
      case "Saline and Alkaline Soil":
        return _englishFallback(_salineSoilEn(), lang, lbl);

      default:
        return {
          "fertRows": [{"icon": "science", "label": lbl("General Recommendation"),
            "value": "Conduct a soil test before applying any fertiliser. Most Indian soils are deficient in nitrogen (universal), phosphorus (widespread), and increasingly zinc."}],
          "amendRows": [{"icon": "healing", "label": lbl("General Amendment"),
            "value": "Add compost or FYM annually to maintain organic matter. Practice crop rotation. Soil-test every 2–3 years at your nearest Krishi Vigyan Kendra (KVK)."}],
        };
    }
  }

  // ── English data for remaining soils (unchanged from original) ──────────

  static Map<String, List<Map<String, String>>> _englishFallback(
    Map<String, List<Map<String, String>>> data,
    String lang,
    String Function(String) lbl,
  ) {
    // Re-label with translated labels, keep English values
    return {
      "fertRows": data["fertRows"]!.map((r) {
        final rawLabel = r["label"] ?? "";
        return {...r, "label": lbl(rawLabel)};
      }).toList(),
      "amendRows": data["amendRows"]!.map((r) {
        final rawLabel = r["label"] ?? "";
        return {...r, "label": lbl(rawLabel)};
      }).toList(),
    };
  }

  static Map<String, List<Map<String, String>>> _blackSoilEn() => {
    "fertRows": [
      {"icon": "science",    "label": "Primary NPK",       "value": "Black soils are rich in K, Ca, and Mg but low in N and P. Apply 80:40:0 kg N:P/ha for cotton (K rarely needed). For wheat: 120:60:40 kg NPK/ha is the standard recommendation."},
      {"icon": "add_circle", "label": "Nitrogen Timing",   "value": "Due to very high water retention and slow drainage, split nitrogen into 3 doses: 1/3 basal, 1/3 at 30 DAS, 1/3 at flowering. Avoid urea top-dressing on waterlogged fields."},
      {"icon": "eco",        "label": "Organic Matter",    "value": "Despite moderate organic content, hot conditions cause rapid mineralisation. Apply compost at 5 t/ha every 2 years. Press mud (sugarcane by-product) is excellent in Maharashtra and Gujarat."},
      {"icon": "biotech",    "label": "Zinc Deficiency",   "value": "Zinc deficiency is the most widespread micronutrient problem in black soils. Apply ZnSO₄ at 25 kg/ha once every 3 years. Foliar spray of 0.5% ZnSO₄ gives rapid correction."},
      {"icon": "warning",    "label": "Watch For",         "value": "Avoid heavy phosphorus applications — black soils fix phosphorus strongly. Use PSB to improve efficiency. Boron deficiency affects cotton and oilseeds — apply borax at 1.5 kg/ha."},
    ],
    "amendRows": [
      {"icon": "loop",    "label": "Gypsum for Drainage",       "value": "Apply gypsum (CaSO₄) at 4–6 t/ha where waterlogging is severe. Calcium from gypsum replaces sodium, flocculating clay particles and opening drainage channels."},
      {"icon": "grass",   "label": "Tillage Timing is Critical","value": "Black soils are extremely plastic when wet and rock-hard when dry. Cultivate only at the 'right moisture' window (approx. 30–40% moisture). Deep ploughing once every 3 years."},
      {"icon": "water",   "label": "Drainage Improvement",      "value": "Install raised beds or broad bed furrow (BBF) systems to prevent waterlogging during kharif. Sub-surface tile drains at 60–80 cm depth have increased cotton yields by over 40%."},
      {"icon": "healing", "label": "Cover Crops in Fallow",     "value": "Sow sorghum or cowpea as cover crops in summer fallow. Deep roots break the subsoil hardpan, and incorporated residues increase carbon. Never leave black soil bare."},
    ],
  };

  static Map<String, List<Map<String, String>>> _lateriteSoilEn() => {
    "fertRows": [
      {"icon": "science",    "label": "Primary NPK",              "value": "Laterite soils are severely leached. Apply heavy NPK: cashew — 500:125:125 g/tree/year; coffee and tea — 30:15:15 g NPK per plant at 3-month intervals."},
      {"icon": "add_circle", "label": "Lime Application",         "value": "Soil pH typically 4.5–6.0. Apply lime at 1–3 t/ha to raise pH above 5.5 before planting. Lime must be incorporated — surface application is ineffective on porous laterite."},
      {"icon": "eco",        "label": "Organic Matter is Critical","value": "Laterite soils have negligible organic carbon. Apply FYM at 20–25 t/ha or green leaf manure at 10 t/ha. Coffee husk compost and coir pith are excellent in Kerala and Karnataka."},
      {"icon": "biotech",    "label": "Phosphorus Management",    "value": "Phosphorus is strongly fixed by iron oxides. Use rock phosphate + PSB bacteria. Dolomitic lime is preferred — it replenishes both Ca and Mg which are rapidly leached."},
      {"icon": "warning",    "label": "Watch For",                "value": "Never leave laterite soil bare — it hardens irreversibly on drying. Always maintain a mulch layer. Iron and aluminium toxicity occurs at pH below 4.5."},
    ],
    "amendRows": [
      {"icon": "loop",    "label": "Organic Matter Addition",  "value": "Apply compost + green leaf manure annually. Target SOC above 1%. Mulching with rubber or coconut palm leaves prevents irreversible hardening."},
      {"icon": "grass",   "label": "Cover Cropping",           "value": "Plant Stylosanthes, Mucuna, or Calopogonium between rows. These legumes fix nitrogen, prevent erosion, and add 2–4 t/ha organic matter annually."},
      {"icon": "water",   "label": "Contour Bunds & Terracing","value": "Laterite soils on slopes are highly erodible. Construct contour bunds, stone walls, or terraces. Trenches along contours capture runoff."},
      {"icon": "healing", "label": "Sub-soiling",              "value": "Deep chiselling at 45 cm depth loosens compacted layers and improves root penetration by 60–80%. Perform during early monsoon."},
    ],
  };

  static Map<String, List<Map<String, String>>> _desertSoilEn() => {
    "fertRows": [
      {"icon": "science",    "label": "Primary NPK",          "value": "Desert soils have naturally high phosphate but very low nitrogen. For bajra: apply 60:30 kg N:P/ha. Concentrate all effort on nitrogen management."},
      {"icon": "add_circle", "label": "Nitrogen Strategy",    "value": "Apply nitrogen in split doses — 50% basal + 50% top dressing after first irrigation. Use neem-coated urea to reduce leaching from porous sandy soil."},
      {"icon": "eco",        "label": "Organic Manure",       "value": "Heavy FYM (20–25 t/ha) simultaneously fertilises AND improves water-holding capacity. Also improves soil biological activity, which is near-zero in bare desert soils."},
      {"icon": "biotech",    "label": "Micronutrient Status", "value": "Alkaline pH (7.5–8.5) reduces micronutrient availability. Apply chelated forms (Fe-EDTA, Zn-EDTA) as foliar sprays for rapid correction."},
      {"icon": "warning",    "label": "Watch For",            "value": "Salinity builds up rapidly with irrigation — monitor EC monthly. Never apply fertilisers to dry soil — concentrated pockets form and damage roots."},
    ],
    "amendRows": [
      {"icon": "loop",    "label": "Water Harvesting First",    "value": "Construct traditional khadin, nadi, or johad to capture monsoon runoff. The Indira Gandhi canal has transformed desert soils of western Rajasthan."},
      {"icon": "grass",   "label": "Organic Matter Build-up",  "value": "Incorporate all crop residues after every harvest. Desert soils with regular organic additions show 3–5× improvement in water retention within 5 years."},
      {"icon": "water",   "label": "Irrigation Efficiency",    "value": "Drip or sprinkler irrigation is essential — flood irrigation wastes 60–70% of water through deep percolation. Drip with fertigation achieves 90%+ efficiency."},
      {"icon": "healing", "label": "Windbreak Planting",       "value": "Plant shelterbelts of Prosopis cineraria (khejri), Acacia tortilis, or Ziziphus nummularia. Windbreaks reduce soil erosion by 50–80%."},
    ],
  };

  static Map<String, List<Map<String, String>>> _mountainSoilEn() => {
    "fertRows": [
      {"icon": "science",    "label": "Primary NPK",               "value": "Mountain soils vary widely. For maize: 120:60:40 kg NPK/ha. For Darjeeling tea: 30N + 15P + 15K per plant annually. Bare slopes need heavy supplementation."},
      {"icon": "add_circle", "label": "Acidic pH Management",      "value": "Many mountain soils are acidic (pH 5.5–6.5). Apply dolomitic lime gradually. For apple orchards in HP, target pH 6.0–6.5 — below this, aluminium toxicity reduces fruit quality."},
      {"icon": "eco",        "label": "Organic Manure",            "value": "Forest leaf litter is the natural amendment — preserve and return it. Supplement with FYM at 10–15 t/ha. In Darjeeling, prunings return 40–60 kg N/ha annually at zero cost."},
      {"icon": "biotech",    "label": "Micronutrients",            "value": "Boron deficiency is widespread in apple orchards of HP and Uttarakhand — causes hollow heart. Apply borax at 1–2 kg/ha or foliar spray of 0.3% boric acid."},
      {"icon": "warning",    "label": "Application Method Matters","value": "Never broadcast fertiliser on steep slopes — rainfall washes it away immediately. Use slow-release fertilisers or fertigation. Apply in shallow trenches or basins."},
    ],
    "amendRows": [
      {"icon": "loop",    "label": "Terracing — Most Important","value": "Construct stone-faced or sod terraces on slopes above 15°. Terracing is the single most effective practice — topsoil loss can reach 40–60 t/ha/year without it."},
      {"icon": "grass",   "label": "Contour Farming",           "value": "Plough and plant along contour lines (across the slope). Contour farming reduces erosion by 50% and increases water infiltration by 35%."},
      {"icon": "water",   "label": "Forest Cover Maintenance",  "value": "Never clear-fell slopes above farmland. Forest cover prevents landslides, reduces runoff velocity, and enriches lower fields. Agro-forestry doubles productivity."},
      {"icon": "healing", "label": "Organic Carbon Build-up",   "value": "Add compost annually and never burn crop residues. Even a 0.3% increase in SOC triples water retention in these shallow soils."},
    ],
  };

  static Map<String, List<Map<String, String>>> _salineSoilEn() => {
    "fertRows": [
      {"icon": "science",    "label": "Choose Fertilisers Carefully","value": "Avoid sodium-based fertilisers — they worsen alkalinity. Prefer calcium ammonium nitrate (CAN) over urea. Apply phosphorus as SSP rather than DAP to add beneficial sulphur."},
      {"icon": "add_circle", "label": "Gypsum — The Key Chemical",  "value": "Gypsum (CaSO₄·2H₂O) at 4–10 t/ha is the most effective treatment for sodic soils. Calcium displaces sodium; sodium sulphate is then flushed by irrigation."},
      {"icon": "eco",        "label": "Organic Amendments",         "value": "FYM at 10–15 t/ha and press mud improve structure and introduce microbes tolerant of high sodium. Organic matter gradually reduces pH over 2–3 seasons."},
      {"icon": "biotech",    "label": "Pyrite for Calcareous Soils","value": "For calcareous alkaline soils that don't respond to gypsum, use iron pyrite (FeS₂) at 5 t/ha. Widely used in Uttar Pradesh and Haryana sodic soils."},
      {"icon": "warning",    "label": "Watch For",                  "value": "Phosphorus, zinc, iron, manganese, and boron all become severely deficient above pH 8.0. Apply chelated micronutrient foliar sprays. Use PSB bacteria."},
    ],
    "amendRows": [
      {"icon": "loop",    "label": "Leaching — Essential First Step","value": "Pond fresh water on the field for 7–10 days (repeat 2–3 times). This dissolves and flushes salts below the root zone. Sub-surface drainage is essential."},
      {"icon": "grass",   "label": "Salt-Tolerant Crop Sequence",  "value": "Begin reclamation with: barley → wheat → berseem → cotton. After 2–3 years, rice can be grown. Dhaincha (Sesbania bispinosa) tolerates pH 10 and fixes nitrogen."},
      {"icon": "water",   "label": "Irrigation Management",        "value": "Apply 15–20% extra leaching fraction to flush salts below the root zone. Drip irrigation keeps salts away from roots more effectively than flood irrigation."},
      {"icon": "healing", "label": "Long-term pH Correction",      "value": "Maintain green cover year-round — bare saline soils re-salinise rapidly. Salt-accumulating plants (Suaeda fruticosa, Salicornia) absorb 0.3–0.5 t NaCl/ha/year."},
    ],
  };

  static IconData _iconForKey(String key) {
    switch (key) {
      case "science":    return Icons.science_outlined;
      case "add_circle": return Icons.add_circle_outline_rounded;
      case "eco":        return Icons.eco_outlined;
      case "biotech":    return Icons.biotech_outlined;
      case "warning":    return Icons.warning_amber_outlined;
      case "loop":       return Icons.loop_rounded;
      case "grass":      return Icons.grass_rounded;
      case "water":      return Icons.water_drop_outlined;
      case "healing":    return Icons.healing_rounded;
      default:           return Icons.info_outline_rounded;
    }
  }

  static IconData iconFor(Map<String, String> row) =>
      _iconForKey(row["icon"] ?? "");
}

// ═══════════════════════════════════════════════════════════════════════════
//  EXPANDABLE SOIL DETAIL CARD
// ═══════════════════════════════════════════════════════════════════════════

class ExpandableSoilDetailCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool loading;
  final bool isFertilizer;
  final String soilType;

  const ExpandableSoilDetailCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.loading,
    required this.isFertilizer,
    required this.soilType,
  });

  @override
  State<ExpandableSoilDetailCard> createState() =>
      _ExpandableSoilDetailCardState();
}

class _ExpandableSoilDetailCardState extends State<ExpandableSoilDetailCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _contentFade;

  static const _teal = Color(0xFF52B3C4);
  static const _expandDuration = Duration(milliseconds: 420);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _expandDuration);
    _expandAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    if (_expanded) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = LangProvider.of(context).langCode;
    final isLoading = widget.loading || widget.value == "--";
    final rows = _SoilDetailData.forSoil(widget.soilType, langCode)[
        widget.isFertilizer ? "fertRows" : "amendRows"] ?? [];

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                final t = _expandAnim.value;
                final borderColor = Color.lerp(
                  Colors.white.withOpacity(0.18),
                  _teal.withOpacity(0.50), t)!;
                final borderWidth = 1.0 + (0.3 * t);
                final iconColor = Color.lerp(
                  isDark ? Colors.white70 : Colors.black54, _teal, t)!;
                final chevronColor = Color.lerp(
                  Colors.white.withOpacity(0.50), _teal, t)!;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: isLoading ? null : _toggle,
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 22, height: 22,
                                child: isLoading
                                    ? _Spinner()
                                    : Icon(widget.icon, size: 22, color: iconColor),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.title,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12, fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white54 : Colors.black45,
                                        letterSpacing: 0.2)),
                                    const SizedBox(height: 4),
                                    isLoading
                                        ? _Shimmer(width: 200)
                                        : Text(widget.value,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14.5, fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.white : Colors.black87,
                                              height: 1.45)),
                                    if (!isLoading) ...[
                                      const SizedBox(height: 6),
                                      Opacity(
                                        opacity: 1.0 - t,
                                        child: Text(
                                          _T.tapForGuidance(langCode),
                                          style: GoogleFonts.dmSans(
                                            fontSize: 11,
                                            color: _teal.withOpacity(0.80),
                                            fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!isLoading)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Transform.rotate(
                                    angle: t * math.pi,
                                    child: Icon(Icons.keyboard_arrow_down_rounded,
                                        size: 22, color: chevronColor)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      ClipRect(
                        child: Align(
                          heightFactor: _expandAnim.value,
                          alignment: Alignment.topCenter,
                          child: FadeTransition(
                            opacity: _contentFade,
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: _DetailPanel(rows: rows),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Inner detail panel ────────────────────────────────────────────────────

class _DetailPanel extends StatelessWidget {
  final List<Map<String, String>> rows;
  const _DetailPanel({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              const Color(0xFF52B3C4).withOpacity(0.40),
              Colors.transparent,
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black.withOpacity(0.18),
              border: Border.all(
                  color: const Color(0xFF52B3C4).withOpacity(0.18), width: 1),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < rows.length; i++)
                  _DetailRow(
                    icon: _SoilDetailData.iconFor(rows[i]),
                    label: rows[i]["label"] ?? "",
                    value: rows[i]["value"] ?? "",
                    isLast: i == rows.length - 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Single detail row ─────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 10 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF52B3C4).withOpacity(0.12),
            ),
            child: Icon(icon, size: 14,
                color: const Color(0xFF52B3C4).withOpacity(0.85)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: const Color(0xFF52B3C4).withOpacity(0.90),
                    letterSpacing: 0.3)),
                const SizedBox(height: 4),
                Text(value,
                  style: GoogleFonts.dmSans(
                    fontSize: 13, fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.82),
                    height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading spinner ───────────────────────────────────────────────────────

class _Spinner extends StatefulWidget {
  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) =>
          Transform.rotate(angle: _c.value * 2 * math.pi, child: child),
      child: Icon(Icons.wb_sunny_rounded, size: 20, color: Colors.orange.shade300),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────────

class _Shimmer extends StatefulWidget {
  final double width;
  const _Shimmer({required this.width});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Container(
        width: widget.width, height: 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white.withOpacity(0.07 + 0.09 * _c.value),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  HELPER — call in _SoilScreenState.build()
// ═══════════════════════════════════════════════════════════════════════════

List<Widget> buildFertilizerAndAmendmentCards(
  Map<String, dynamic> soilData,
  String soilType,
  AppLocalizations l,
) {
  final fertValue  = soilData["fertilizer"] as String? ?? "--";
  final amendValue = soilData["amendment"]  as String? ?? "--";

  return [
    ExpandableSoilDetailCard(
      title:        l.t("fertilizer_advice"),
      value:        fertValue,
      icon:         Icons.agriculture_rounded,
      loading:      fertValue  == "--",
      isFertilizer: true,
      soilType:     soilType,
    ),
    ExpandableSoilDetailCard(
      title:        l.t("soil_amendment"),
      value:        amendValue,
      icon:         Icons.healing_rounded,
      loading:      amendValue == "--",
      isFertilizer: false,
      soilType:     soilType,
    ),
  ];
}