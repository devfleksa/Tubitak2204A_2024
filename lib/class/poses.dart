class Pose {
  const Pose({
    required this.name,
    required this.description,
    required this.imageFile,
    this.descriptionImageFile,
    this.steps,
  });

  final String name;
  final String description;
  final String imageFile;

  final String? descriptionImageFile;
  final List<String>? steps;
}

const kneePoses = [
  Pose(
    name: 'Sağ Kalça-Abdüksiyon',
    description: 'description',
    imageFile: 'assets/hip_abducation.jpg',
    descriptionImageFile: 'assets/hip_abducation.jpg',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile karşınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sol elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı yana doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın. Bu sırada sol ayağınızın yere sağlam basmasına ve dengenizin korunmasına dikkat edin.',
      'Yavaşça İndirme: Sağ bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, Sağ kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sol Kalça-Abdüksiyon',
    description: 'description',
    imageFile: 'assets/hip_abducation.jpg',
    descriptionImageFile: 'assets/hip_abducation.jpg',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile karşınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sağ elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı yana doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın. Bu sırada sağ ayağınızın yere sağlam basmasına ve dengenizin korunmasına dikkat edin.',
      'Yavaşça İndirme: Sol bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, Sol kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sağ Kalça-Hiperekstansiyon',
    description: 'description',
    imageFile: 'assets/hip_hiperekstansiyon.jpg',
    descriptionImageFile: 'assets/hip_hiperekstansiyon.jpg',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile sağ tarafınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sağ elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı arkaya doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın.',
      'Yavaşça İndirme: Sağ bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, sağ kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sol Kalça-Hiperekstansiyon',
    description: 'description',
    imageFile: 'assets/hip_hiperekstansiyon.jpg',
    descriptionImageFile: 'assets/hip_hiperekstansiyon.jpg',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile sol tarafınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sol elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı arkaya doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın.',
      'Yavaşça İndirme: Sol bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, sol kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sağ Kalça-Ekstansiyon',
    description: 'description',
    imageFile: 'assets/hip_fleksiyon.png',
    descriptionImageFile: 'assets/hip_fleksiyon.png',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile sağ tarafınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sağ elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı öne doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın.',
      'Yavaşça İndirme: Sağ bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, sağ kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sol Kalça-Ekstansiyon',
    description: 'description',
    imageFile: 'assets/hip_fleksiyon.png',
    descriptionImageFile: 'assets/hip_fleksiyon.png',
    steps: [
      'Hazırlık: Telefonunuzu duvar veya duvara benzeyen düz bir nesne ile sol tarafınıza yerleştirin. Tüm vücudunuzun kadraja girdiğinden, ışık seviyesi ve kamera kalitesini olumsuz etkileyecek etkenler olmadığından emin olun. Düz bir zemin üzerinde ayakta durun ve dengenizi sağlamak için sol elinizle bir masa, sandalye ya da sabit bir nesneyi hafifçe tutun.',
      'Egzersizin Yapılışı: Kalça kaslarınızı kullanarak bacağınızı öne doğru açın ve bu pozisyonda birkaç saniye bekleyin. Bacak yukarıdayken vücudunuzun diğer kısımlarını sabit tutmaya çalışın.',
      'Yavaşça İndirme: Sol bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna geri indirin. Hareket sırasında bacağınızı kontrollü bir şekilde indirmeye özen gösterin.',
      'Tekrar Sayısı: Bu hareketi toplamda 5 kez tekrarlayın. Her tekrarda, sol kalça kaslarınızın çalıştığını hissetmeye odaklanın.',
      'Denge ve Kontrol: Egzersizi yaparken, vücudunuzun geri kalan kısmını mümkün olduğunca sabit tutun. Bu, kalça kaslarınıza odaklanmanıza ve dengeyi korumanıza yardımcı olacaktır. Hareketi yaparken nefesinizi düzenli tutun.'
    ],
  ),
  Pose(
    name: 'Sağ Diz-Fleksiyon',
    description: 'description',
    imageFile: 'assets/knee_leg_rise.jpg',
    descriptionImageFile: 'assets/knee_leg_rise.jpg',
    steps: [
      '1- Düz bir sandalyeye dik bir şekilde oturun ve ayaklarınız yere değmeyecek şekilde yerleştirin.',
      '2- Sırtınızı dik tutarken, karın kaslarınızı sıkılaştırın ve omuzlarınızı geriye doğru çekin.',
      '3- Sağ bacağınızı yavaşça kaldırarak dizinizden bükün ve ayağınız yere değmeyecek şekilde düz bir çizgi halinde uzatın.',
      '4- Bu pozisyonu birkaç saniye boyunca sabit tutun.',
      '5- Daha sonra sağ bacağınızı yavaşça başlangıç pozisyonuna indirin ve düzgün bir şekilde yerleştirin.',
    ],
  ),
  Pose(
    name: 'Sol Diz-Fleksiyon',
    description: 'description',
    imageFile: 'assets/knee_leg_rise.jpg',
    descriptionImageFile: 'assets/knee_leg_rise.jpg',
    steps: [
      '1- Düz bir sandalyeye dik bir şekilde oturun ve ayaklarınız yere değmeyecek şekilde yerleştirin.',
      '2- Sırtınızı dik tutarken, karın kaslarınızı sıkılaştırın ve omuzlarınızı geriye doğru çekin.',
      '3- Sol bacağınızı yavaşça kaldırarak dizinizden bükün ve ayağınız yere değmeyecek şekilde düz bir çizgi halinde uzatın.',
      '4- Bu pozisyonu birkaç saniye boyunca sabit tutun.',
      '5- Daha sonra sol bacağınızı yavaşça başlangıç pozisyonuna indirin ve düzgün bir şekilde yerleştirin.',
    ],
  ),
];
