import 'package:firebase_oa/view/home/patient/exercise/pose_detection_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseInfoView extends StatelessWidget {
  const ExerciseInfoView({
    super.key,
    required this.title,
    required this.reps,
    required this.minAngle,
    required this.gifPath,
    required this.id,
  });

  final String id;
  final String title;
  final int reps;
  final double minAngle;
  final String gifPath;

  @override
  Widget build(BuildContext context) {
    const TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    const TextStyle regularStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
    );

    List<String> setSteps(String exercise) {
      switch (exercise) {
        case 'Sağ Kalça-Abdüksiyon':
          return [
            'Telefonunuzu karşıya, duvar gibi düz bir yüzeye yerleştirin.',
            'Işık ve kamera kalitesini kontrol edin.',
            'Ayakta durun, sol elinizle bir masa ya da sandalyeye hafifçe tutunarak dengenizi sağlayın.',
            'Sağ bacağınızı yana doğru kaldırarak kalça kaslarınızı kullanın.',
            'Bacağınız havadayken birkaç saniye bekleyin ve vücudunuzun geri kalanını sabit tutun.',
            'Sağ bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna indirin.',
            'Hareketi $reps kez tekrarlayın. Her tekrarla birlikte sağ kalça kaslarınızın çalıştığını hissedin.'
          ];
        case 'Sol Kalça-Abdüksiyon':
          return [
            'Telefonunuzu karşıya, duvar gibi düz bir yüzeye yerleştirin.',
            'Işık ve kamera kalitesini kontrol edin.',
            'Ayakta durun, sağ elinizle bir masa ya da sandalyeye hafifçe tutunarak dengenizi sağlayın.',
            'Sol bacağınızı yana doğru kaldırarak kalça kaslarınızı kullanın.',
            'Bacağınız havadayken birkaç saniye bekleyin ve vücudunuzun geri kalanını sabit tutun.',
            'Sol bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna indirin.',
            'Hareketi $reps kez tekrarlayın. Her tekrarla birlikte sol kalça kaslarınızın çalıştığını hissedin.',
          ];
        case 'Sağ Kalça-Hiperekstansiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Düz bir zeminde ayakta durun ve dengenizi sağlamak için destek noktası bulun.',
            'Kalça kaslarınızı kullanarak sağ bacağınızı arkaya doğru açın.',
            'Bacağınız havada iken birkaç saniye bekleyin ve vücudunuzun diğer bölümlerini sabit tutun.',
            'Sağ bacağınızı kontrollü bir şekilde yavaşça başlangıç pozisyonuna indirin.',
            'Bu hareketi $reps kez tekrarlayın. Her tekrarda sağ kalça kaslarınızın çalıştığını hissetmeye çalışın.',
          ];
        case 'Sol Kalça-Hiperekstansiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Düz bir zeminde ayakta durun ve dengenizi sağlamak için destek noktası bulun.',
            'Kalça kaslarınızı kullanarak sol bacağınızı arkaya doğru açın.',
            'Bacağınız havada iken birkaç saniye bekleyin ve vücudunuzun diğer bölümlerini sabit tutun.',
            'Sol bacağınızı kontrollü bir şekilde yavaşça başlangıç pozisyonuna indirin.',
            'Bu hareketi $reps kez tekrarlayın. Her tekrarda sol kalça kaslarınızın çalıştığını hissetmeye çalışın.',
          ];
        case 'Sağ Kalça-Ekstansiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Düz bir zeminde ayakta durun ve dengenizi sağlamak için destek noktası bulun.',
            'Kalça kaslarınızı kullanarak sağ bacağınızı öne doğru açın.',
            'Bacağınız havada iken birkaç saniye bekleyin ve vücudunuzun diğer bölümlerini sabit tutun.',
            'Sağ bacağınızı kontrollü bir şekilde yavaşça başlangıç pozisyonuna indirin.',
            'Bu hareketi $reps kez tekrarlayın. Her tekrarda sağ kalça kaslarınızın çalıştığını hissetmeye çalışın.',
          ];
        case 'Sol Kalça-Ekstansiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Düz bir zeminde ayakta durun ve dengenizi sağlamak için destek noktası bulun.',
            'Kalça kaslarınızı kullanarak sol bacağınızı öne doğru açın.',
            'Bacağınız havada iken birkaç saniye bekleyin ve vücudunuzun diğer bölümlerini sabit tutun.',
            'Sol bacağınızı kontrollü bir şekilde yavaşça başlangıç pozisyonuna indirin.',
            'Bu hareketi $reps kez tekrarlayın. Her tekrarda sol kalça kaslarınızın çalıştığını hissetmeye çalışın.',
          ];
        case 'Sağ Diz-Fleksiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Düz bir sandalyeye dik bir şekilde oturun. Ayaklarınızın yere değmediğinden emin olun.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Sağ bacağınızı yavaşça kaldırın, dizinizden bükün ve ayağınız yere değmeyecek şekilde düz bir çizgide uzatın.',
            'Bu pozisyonu birkaç saniye boyunca sabit tutun.',
            'Sağ bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna indirin ve düzgün bir şekilde yerleştirin.',
            'Bu hareketi $reps kez tekrarlayın.',
          ];
        case 'Sol Diz-Fleksiyon':
          return [
            'Telefonunuzu sağ veya sol tarafınıza, düz bir yüzeye yerleştirin.',
            'Düz bir sandalyeye dik bir şekilde oturun. Ayaklarınızın yere değmediğinden emin olun.',
            'Tüm vücudunuz kadraja sığdığından ve aydınlatmanın yeterli olduğundan emin olun.',
            'Sol bacağınızı yavaşça kaldırın, dizinizden bükün ve ayağınız yere değmeyecek şekilde düz bir çizgide uzatın.',
            'Bu pozisyonu birkaç saniye boyunca sabit tutun.',
            'Sol bacağınızı yavaşça ve kontrollü bir şekilde başlangıç pozisyonuna indirin ve düzgün bir şekilde yerleştirin.',
            'Bu hareketi $reps kez tekrarlayın.',
          ];
        default:
          return [''];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Image.asset(gifPath),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Tekrar: ',
                      style: boldStyle,
                    ),
                    TextSpan(
                      text: reps.toString(),
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Açı: ',
                      style: boldStyle,
                    ),
                    TextSpan(
                      text: minAngle.toString(),
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 2,
            ),
          ),
          const SizedBox(height: 5),
          for (var step in setSteps(title))
            ListTile(
              leading: const Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Colors.blue,
              ),
              title: Text(
                step,
                style: regularStyle,
                textAlign: TextAlign.left,
              ),
            ),
          const SizedBox(height: 55),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAll(
            () => PoseDetectorView(
              id: id,
              currentExerciseName: title,
              reps: reps,
              minAngle: minAngle,
            ),
          );
        },
        label: const Text('Egzersize Başla'),
      ),
    );
  }
}
