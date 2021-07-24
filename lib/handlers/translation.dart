import 'package:DriversMobile/handlers/sharedPreference.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Translation {
  static const languages = ["Eng", "Amh"];

  static const Dictionary = {
    "name": "ስም",
    "registration": "ምዝገባ  ",
    "register": "ተመዝገብ",
    "username": "መለያ ስም",
    "motor": "ሞተር ",
    "select theme": "ቲም ምረጥ",
    "category": "ምድብ ",
    "result": "ውጤት",
    "question": "ጥያቄ",
    "questions": "ጥያቄዎች",
    "setting": "ቅንብር",
    "settings": " ቅንብሮች ",
    "select language": "ቋንቋ ምረጥ",
    "eng": "Eng",
    "amh": "አማርኛ",
    "register your name including the companiese password":
        "ስምዎን እና የ ድርጅቱን ይለፍ ቃል በማስገባት ይመዝገቡ። ",
    "company password": "የድርጅቱ ይለፍ ቃል",
    "skip": "ዝለል",
    "next": "ቀጣይ",
    "previous": "ቀዳሚው",
    "question page": "የጥያቄ ገፅ",
    "answers": "መልሶች ",
    "answer": "መልስ",
    "group number": "የቡድን ቁጥር",
    "start": "ጀምር",
    "go to categories": "ወደ ዘርፍ ገፅ ሂድ",
    "results": "ውጤቶች",
    "unset": "አልተወሰነም",
    "level": "ደረጃ",
    "levels": "ደረጃዎች",
    "categories": "ዘርፎች ",
    "submit": "አስረክብ",
    "change username": "መለያ ስም ይቀይሩ",
    "can't skip this question": "ጥያቄውን መዝለል አይችሉም",
    "no other question to preview": "ከዚህ በፊት ሌላ ጥያቄዎች የሉም",
    "wait wait ...": "ቆይ ቆይ ...",
    "wait a second ...": "ቆይ አንዴ",
    "first ! answer this question": "መጀመሪያ ፤ ይሄን ጥያቄ ይመልሱ!",
    "ok": "እሺ",
    "internal error": "የውስጥ ችግር",
    "internal error while reseting result ! please try again.":
        "ውጤቱን ሲያጠፉ የውስጥ ችግር ተፈጥሯል ፤ እባክዎ በድጋሚ ይሞክሩ ",
    "reset results": "ውጤቶቹን አጥፋ",
    "others": "ሌሎች",
    'company password ....': "የድርጅቱ ይለፍ ቃል ... ",
    "loading": "በመጫን ላይ",
    "internal code error. \nplease try again....":
        "yewust chigr tefetrual \nebakwo bedgami yimokru",
    "incorrect company password": "yetesasate yedrjit yilef kal",
    "please fill the name correctly": " ebakwo smwon bemigeba yimulu",
    "invalid password! \n try the company pasword correctly":
        " yetesasate yilef kal \n ebakwo ye drjitun yilef kal bedgami yimokru",
    "please fiil the input fields":
        "ebakwo mereja mekebeyawochun bemigeba yimulu",
    "invalid character length \n character length has to be greater than 2":
        "የተሳሣተ የፊደል ብዛት\n የፊደሎች ብዛት ከ 2 መብለጥ አለበት",
    "username changed succesfully": "መለያ ስም በሚገባ ተቀይሯል",
    "motor cycle": "ሞተር ሳይክል",
    "other vehicles": "ሌሎች ተሽከርካሪዎች",
    "about us": "ስለ እኛ",
    "email": 'ኢሜል',
    "description": "ማብራሪያ",
    "address": "አድራሻ",
    'phones': "ስልኮች",
    "phone": "ስልክ",
    "or": "ወይም",
    "app developer": "መተግበሪያ አበልፃጊ",
    "samuael adnew": "ሳሙኤል አድነው",
    "hawasa : ethiopia  , atotet : wolde amanuael road infront of hayole school":
        " ሀዋሳ ኢትዬጽያ አቶቴ ፡ ወልድ አማኑኤል መንገድ ከሀዮሌ ት/ት ቤት ፊት ለፊት",
    "gebriel area , o4 kebele  , assosa , benishangul gumz ,ethiopia":
        "ገብርኤል ሰፈር ፡ 04 ቀበሌ ፡አሶሳ ፡ ቤንሻንጉል ጉምዝ ፡ ኢትዮጽያ",
    "saddle dam drivers training institute \nwe thrive to create intelligent and expert drivers and to create traffic accident free surrounding.\n come and visit us you shall have a better knowledge.":
        "ሳድል ዳም የአሽከርካሪዎች ማሰልጠኛ ተቋም \n ብቁና የላቁ አሽከርካሪዎችን በማፍራት ከትራፊክ አደጋ የፀዳ የተሽከርካሪ ቀጠና ለመፍጠር እንተጋለን።\n ይምጡና ይጎብኙን የተሻለ እውቀት ከእኛ ጋር ያገኛሉ ።",
    "shambel drivers training institute \nwe thrive to create intelligent and expert drivers and to create traffic accident free surrounding.\n come and visit us you shall have a better knowledge.":
        "ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም \n ብቁና የላቁ አሽከርካሪዎችን በማፍራት ከትራፊክ አደጋ የፀዳ የተሽከርካሪ ቀጠና ለመፍጠር እንተጋለን።\n ይምጡና ይጎብኙን የተሻለ እውቀት ከእኛ ጋር ያገኛሉ ።",
    "a": "ሀ",
    "b": "ለ",
    "c": "ሐ",
    "d": "መ",
    "e": "ሰ",
    "f": "ረ",
    "g": "ሠ",
    "question and answer for driving trainees":
        "የተሽከርካሪ ሰልጣኞች መለማመጃ ጥያቄ እና መልስ",
    "grade result": "የፈተና ውጤት",
    "group": "ፈተና",
    "select category": "ምድብ ምረጥ",
    "your are not allowed to access questions\nchoose a group first":
        "ጥያቄዎችን ለመፈተን አይችሉም \n መጀመሪያ የጥያቄ ቡድን ይመረጡ",
    "total": "ድምር",
    "test": "ፈተና",
    "test number": "ፈተና ቁጥር",
    "the": "የ",
    "vehicles": "ተሽከርካሪዎች",
    "cycle": "ሳይክል",
    "theme change": "የቲም ለውጥ",
    "exit app": "መተግበሪያውን ዝጋ",
    "cancel": "ይቅር",
    "to apply the change . restart the app !":
        "የቲም ለውጡ ተግባራዊ እንዲሆን ፤መተግበርሪያውን ዘግተው ትክፈቱት",
    "eg. name : muhammed": "ምሳሌ፦ ስም ፡ ሙሀመድ",
    "icons": "ምልክቶች",
    "icon": "ምልክት",
    "icon question": "የምልክት ጥያቄ",
    "change theme": "ቲም ቀይር",
    "english": "እንግሊዝኛ",
    "amharic": "አማርኛ",
    "welcome!": "እንኳን ደህና መጡ።",
    "initialize questions by pressing the start button":
        "የ \'ጅምር\' ማዘዣውን በመጫን ጥያቄዎችን ያስጅምሩ።",
    "loading questions may take time please be patient!":
        "የመጫን ሂደት ጊዜ ሊውስድ ስለሚችል እባክዎ በትእግስት ይጠብቁ",
    "no more question!": "ፈተናው እልቋል!",
    "you have done all the questions of this test!": "የዚህን ፈተና ጥያቄዎች  ጨርሰዋል።\n",
    "your score is": "ውጤትዎ",
    "to re-take this test,\nreset the result of this test in the grade result page!":
        "\nድጋሚ ለመፈተን ውጤቱን ከውጤት ገፅ ይሰርዙ።",
    // "motor": "ሞተር",
    // "others": "",
    // "icons": "ምልክቶች",
  };

  static String translate(String lang, String sentence) {
    if (lang == "" || lang == "eng" || sentence == null) {
      return (sentence != null ? sentence : " ");
    } else if (lang == "amh" ||
        lang == "AMH" ||
        lang == "Amh" ||
        lang == "AMh" ||
        lang == "AmH" ||
        lang == "aMh") {
      final valuue = Dictionary[sentence.toLowerCase().trim()];
      if (valuue == "") {
        return (sentence != null ? sentence : " ");
      }
      return valuue;
    } else {
      return (sentence != null ? sentence : " ");
    }
  }

  static String translateIt(String sentence) {
    final userdata = UserData.getInstance();
    String language;
    userdata.GetLanguage().then((lang) {
      language = lang;
    });

    return translate(language, sentence);
  }
}
