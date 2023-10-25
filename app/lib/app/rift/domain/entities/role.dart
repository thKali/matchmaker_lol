import 'package:flutter/material.dart';

enum Role {
  top,
  jungle,
  mid,
  adc,
  sup,
  random;

  Image get icon {
    switch (this) {
      case Role.top:
        return Image.asset('assets/roles/Position_Challenger-Top.png');
      case Role.jungle:
        return Image.asset('assets/roles/Position_Challenger-Jungle.png');
      case Role.mid:
        return Image.asset('assets/roles/Position_Challenger-Mid.png');
      case Role.adc:
        return Image.asset('assets/roles/Position_Challenger-Bot.png');
      case Role.sup:
        return Image.asset('assets/roles/Position_Challenger-Support.png');
      default:
        return Image.asset('assets/roles/Position_Challenger-Random.png');
    }
  }

}
