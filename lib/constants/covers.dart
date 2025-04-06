import 'dart:math';
import "package:path/path.dart" as path;

class Covers {
  static String getRandomCover() {
    final random = Random();
    final covers = [...Covers.cultural, ...Covers.natural, ...Covers.film];

    return covers[random.nextInt(covers.length)];
  }

  static String getLocalCover() {
    return Covers.local[0];
  }

  static List<String> natural = [
    "https://images.unsplash.com/photo-1586768798120-95597acaa6e3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740004731264-3cde5c198cc2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3fHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1740415924695-df06f4e1ab50?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDh8NnNNVmpUTFNrZVF8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740387223785-6ab827ab4fb1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1734865266315-bfa6776eed4b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE2fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://plus.unsplash.com/premium_photo-1736378273167-5ea5722ddaa0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDI2fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739992103066-cd16de07e728?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDM4fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://plus.unsplash.com/premium_photo-1669868118193-1d39f8baf75a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDM5fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739536176048-caa7190dba66?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDQ0fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739367156315-22b8ce82b23b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDU4fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1738762389606-7cd5ccc09753?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDYyfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://plus.unsplash.com/premium_photo-1739123306475-2b43e0d3829f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDYzfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1735323656411-a43ad7822c90?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDY1fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://plus.unsplash.com/premium_photo-1675017879793-5cf5f9ed2902?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDczfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1737100593814-8ceb04f29cca?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDgyfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1737439987404-a3ee9fb95351?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDExNXw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1585951301678-8fd6f3b32c7e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDEyMnw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737496538329-a59d10148a08?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDEyNnw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737464604499-ced062ab5958?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDEzMHw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1735748917573-78c3387fc8ec?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDEzOHw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737142928492-13e7b0efe912?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE0MHw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1735767976699-6096acda642d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE0OHw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://plus.unsplash.com/premium_photo-1673264933459-808963ed1594?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1MXw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1736841131662-ab6fc065124a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE2MHw2c01WalRMU2tlUXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1740525009604-cf420e1399e6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2OHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740387223785-6ab827ab4fb1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMDF8fHxlbnwwfHx8fHw%3D"
    "https://images.unsplash.com/photo-1738096294977-3bf7225f9a6a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNzN8fHxlbnwwfHx8fHw%3D"
  ];

  static List<String> cultural = [
    "https://plus.unsplash.com/premium_photo-1734155859178-840154a6c11d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw5fHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737961755792-4175df6444b2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyN3x8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740487093135-a1280497b901?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzNHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740560601721-fb8482c42b64?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzNnx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740612209846-de5b844a64b8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzOXx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740367217559-de1dcaafafe3?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1Mnx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1740487092927-d6e9d14373cb?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1NXx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1732813963186-f03b882873e6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMDV8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1735276734563-b4fa7491ae7d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMTB8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739414487275-c5258a576bd9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMjV8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1724271362937-391a150db603?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMzd8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1740367217706-21861b7eb4ff?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxOTR8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1740165886249-ec4b5785acf4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyNDF8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739800105257-aba885199b43?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzMDd8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739924144825-4544ec14ee29?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzMTd8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739911014029-84f4d78f86d4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzODF8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739890390449-609b1c6d2125?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzOTF8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1736618626242-542735175261?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0NTd8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739641375724-dfea74e0df69?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0Nzd8fHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739518805568-41e07e3318b8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0Nzh8fHxlbnwwfHx8fHw%3D",
  ];

  static List<String> film = [
    "https://images.unsplash.com/photo-1740299201166-a6251c4092c9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIxfGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D"
    "https://images.unsplash.com/photo-1740299200666-4090194b3adf?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIyfGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1740299200525-79bee914fd20?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDI1fGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739131188330-042fcb7b95e4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDM3fGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739785799280-1f21b8ecfccd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDQwfGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739036606854-b2b160a8e006?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDczfGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1739502858922-ca84cb5a7a50?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDc5fGhtZW52UWhVbXhNfHxlbnwwfHx8fHw%3D",
    "https://images.unsplash.com/photo-1737985827822-071a00a82fec?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1MHxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1736339199391-2ddd1cbd3cf3?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1NXxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1627953385320-1ccf8610c70a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE2MnxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737325384669-d5ce723855d7?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE3NnxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1737481718711-ebca35b0dd38?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE4NnxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1736627829937-1f19b66adc00?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIxOHxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1736167852508-105cb125e645?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIzMnxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1733940499704-4371ff8b7117?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDI5NnxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1733970730195-9ac7cb726eee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDMxMHxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1733966007271-107ded9bd0fd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDMxMXxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1733863809303-c22736402205?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDMyMXxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1732639205679-d316e7d7c71b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDQwMXxobWVudlFoVW14TXx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1731642026477-40594a853b66?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDQyOXxobWVudlFoVW14TXx8ZW58MHx8fHx8",
  ];

  static List<String> local = [
    path.join("assets", "images", "cover-1.jpg"),
    path.join("assets", "images", "cover-2.jpg"),
    path.join("assets", "images", "cover-3.jpg"),
  ];
}