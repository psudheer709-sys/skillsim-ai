export const supportedLocales = ['en', 'te', 'hi', 'ta'] as const;
export type Locale = (typeof supportedLocales)[number];

export const localeNames: Record<Locale, string> = {
  en: 'English',
  te: 'తెలుగు',
  hi: 'हिन्दी',
  ta: 'தமிழ்',
};

const english = {
  'language.label': 'Language',
  'language.explanation': 'Explain concepts in',
  'language.deviceNote': 'Saved on this device',
  'shell.workspace': 'Workspace',
  'shell.learningWorkspace': 'Learning workspace',
  'shell.progressSaved': 'Progress is saved to your account',
  'shell.tagline': 'A focused space to practise, reflect and grow',
  'shell.loading': 'Loading your workspace…',
  'shell.tryAgain': 'Try again',
  'shell.signInAgain': 'Sign in again',
  'shell.logOut': 'Log out',
  'nav.overview': 'Overview',
  'nav.learningPath': 'My Learning Path',
  'nav.careerRoadmaps': 'Career Roadmaps',
  'nav.simulations': 'Simulations',
  'nav.mistakeDna': 'Mistake DNA',
  'nav.recommendations': 'AI Recommendations',
  'nav.skillPassport': 'Skill Passport',
  'nav.submissions': 'My Submissions',
  'nav.achievements': 'Achievements',
  'nav.profile': 'Profile',
  'nav.settings': 'Settings',
  'nav.educator': 'Educator overview',
  'nav.admin': 'Administrator workspace',
  'nav.institutions': 'Institution workspace',
  'nav.careerEngine': 'Career Engine',
  'assistant.title': 'AI learning assistant',
  'assistant.subtitle': 'Ask for an explanation, study plan, or practice hint.',
  'assistant.ask': 'Ask your learning assistant',
  'assistant.placeholder': 'What would you like to understand?',
  'assistant.you': 'You',
  'assistant.send': 'Send message',
} as const;

export type TranslationKey = keyof typeof english;
export const translationKeys = Object.keys(english) as TranslationKey[];
type Dictionary = Record<TranslationKey, string>;

const dictionaries: Record<Locale, Dictionary> = {
  en: english,
  te: {
    'language.label': 'భాష', 'language.explanation': 'భావనలను ఈ భాషలో వివరించండి', 'language.deviceNote': 'ఈ పరికరంలో సేవ్ చేయబడింది',
    'shell.workspace': 'వర్క్‌స్పేస్', 'shell.learningWorkspace': 'అభ్యాస వర్క్‌స్పేస్', 'shell.progressSaved': 'మీ పురోగతి మీ ఖాతాలో సేవ్ అవుతుంది', 'shell.tagline': 'సాధన, ఆలోచన, అభివృద్ధి కోసం ప్రత్యేక స్థలం', 'shell.loading': 'మీ వర్క్‌స్పేస్ లోడ్ అవుతోంది…', 'shell.tryAgain': 'మళ్లీ ప్రయత్నించండి', 'shell.signInAgain': 'మళ్లీ సైన్ ఇన్ చేయండి', 'shell.logOut': 'లాగ్ అవుట్',
    'nav.overview': 'సారాంశం', 'nav.learningPath': 'నా అభ్యాస మార్గం', 'nav.careerRoadmaps': 'కెరీర్ రోడ్‌మ్యాప్‌లు', 'nav.simulations': 'సిమ్యులేషన్లు', 'nav.mistakeDna': 'తప్పుల విశ్లేషణ', 'nav.recommendations': 'AI సూచనలు', 'nav.skillPassport': 'స్కిల్ పాస్‌పోర్ట్', 'nav.submissions': 'నా సమర్పణలు', 'nav.achievements': 'విజయాలు', 'nav.profile': 'ప్రొఫైల్', 'nav.settings': 'సెట్టింగ్‌లు', 'nav.educator': 'బోధకుడి సారాంశం', 'nav.admin': 'నిర్వాహక వర్క్‌స్పేస్', 'nav.institutions': 'సంస్థ వర్క్‌స్పేస్', 'nav.careerEngine': 'కెరీర్ ఇంజిన్',
    'assistant.title': 'AI అభ్యాస సహాయకుడు', 'assistant.subtitle': 'వివరణ, చదువు ప్రణాళిక లేదా సాధన సూచన అడగండి.', 'assistant.ask': 'మీ అభ్యాస సహాయకుడిని అడగండి', 'assistant.placeholder': 'మీరు ఏ విషయం తెలుసుకోవాలనుకుంటున్నారు?', 'assistant.you': 'మీరు', 'assistant.send': 'సందేశం పంపండి',
  },
  hi: {
    'language.label': 'भाषा', 'language.explanation': 'अवधारणाएँ इस भाषा में समझाएँ', 'language.deviceNote': 'इस डिवाइस पर सेव',
    'shell.workspace': 'कार्यस्थल', 'shell.learningWorkspace': 'अध्ययन कार्यस्थल', 'shell.progressSaved': 'आपकी प्रगति आपके खाते में सेव है', 'shell.tagline': 'अभ्यास, चिंतन और विकास के लिए एक जगह', 'shell.loading': 'आपका कार्यस्थल लोड हो रहा है…', 'shell.tryAgain': 'फिर से कोशिश करें', 'shell.signInAgain': 'फिर से साइन इन करें', 'shell.logOut': 'लॉग आउट',
    'nav.overview': 'अवलोकन', 'nav.learningPath': 'मेरा अध्ययन पथ', 'nav.careerRoadmaps': 'करियर रोडमैप', 'nav.simulations': 'सिमुलेशन', 'nav.mistakeDna': 'गलतियों का विश्लेषण', 'nav.recommendations': 'AI सुझाव', 'nav.skillPassport': 'स्किल पासपोर्ट', 'nav.submissions': 'मेरे सबमिशन', 'nav.achievements': 'उपलब्धियाँ', 'nav.profile': 'प्रोफ़ाइल', 'nav.settings': 'सेटिंग्स', 'nav.educator': 'शिक्षक अवलोकन', 'nav.admin': 'प्रशासक कार्यस्थल', 'nav.institutions': 'संस्थान कार्यस्थल', 'nav.careerEngine': 'करियर इंजन',
    'assistant.title': 'AI अध्ययन सहायक', 'assistant.subtitle': 'व्याख्या, अध्ययन योजना या अभ्यास संकेत पूछें।', 'assistant.ask': 'अपने अध्ययन सहायक से पूछें', 'assistant.placeholder': 'आप क्या समझना चाहते हैं?', 'assistant.you': 'आप', 'assistant.send': 'संदेश भेजें',
  },
  ta: {
    'language.label': 'மொழி', 'language.explanation': 'கருத்துகளை இந்த மொழியில் விளக்கவும்', 'language.deviceNote': 'இந்தச் சாதனத்தில் சேமிக்கப்பட்டது',
    'shell.workspace': 'பணியிடம்', 'shell.learningWorkspace': 'கற்றல் பணியிடம்', 'shell.progressSaved': 'உங்கள் முன்னேற்றம் கணக்கில் சேமிக்கப்படுகிறது', 'shell.tagline': 'பயிற்சி, சிந்தனை, வளர்ச்சிக்கான இடம்', 'shell.loading': 'உங்கள் பணியிடம் ஏற்றப்படுகிறது…', 'shell.tryAgain': 'மீண்டும் முயற்சிக்கவும்', 'shell.signInAgain': 'மீண்டும் உள்நுழையவும்', 'shell.logOut': 'வெளியேறு',
    'nav.overview': 'கண்ணோட்டம்', 'nav.learningPath': 'எனது கற்றல் பாதை', 'nav.careerRoadmaps': 'தொழில் வழிகாட்டிகள்', 'nav.simulations': 'செயல்முறைப் பயிற்சிகள்', 'nav.mistakeDna': 'பிழை பகுப்பாய்வு', 'nav.recommendations': 'AI பரிந்துரைகள்', 'nav.skillPassport': 'திறன் பாஸ்போர்ட்', 'nav.submissions': 'எனது சமர்ப்பிப்புகள்', 'nav.achievements': 'சாதனைகள்', 'nav.profile': 'சுயவிவரம்', 'nav.settings': 'அமைப்புகள்', 'nav.educator': 'ஆசிரியர் கண்ணோட்டம்', 'nav.admin': 'நிர்வாகப் பணியிடம்', 'nav.institutions': 'நிறுவனப் பணியிடம்', 'nav.careerEngine': 'தொழில் வழிகாட்டி',
    'assistant.title': 'AI கற்றல் உதவியாளர்', 'assistant.subtitle': 'விளக்கம், படிப்பு திட்டம் அல்லது பயிற்சி குறிப்பைக் கேளுங்கள்.', 'assistant.ask': 'உங்கள் கற்றல் உதவியாளரிடம் கேளுங்கள்', 'assistant.placeholder': 'நீங்கள் எதைப் புரிந்துகொள்ள விரும்புகிறீர்கள்?', 'assistant.you': 'நீங்கள்', 'assistant.send': 'செய்தி அனுப்பு',
  },
};

export function isLocale(value: unknown): value is Locale {
  return typeof value === 'string' && (supportedLocales as readonly string[]).includes(value);
}

export function translate(locale: Locale, key: TranslationKey): string {
  return dictionaries[locale][key] ?? english[key];
}

export function getLocaleName(locale: Locale): string {
  return localeNames[locale];
}
