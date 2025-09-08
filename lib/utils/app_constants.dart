import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class AppConstants {
  static final List<String> genres = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Family",
    "Fantasy",
    "Film-Noir",
    "History",
    "Horror",
    "Music",
    "Musical",
    "Mystery",
    "Romance",
    "Sci-Fi",
    "Sport",
    "Thriller",
    "War",
    "Western",
  ];
  static String getLocalizedGenre(BuildContext context, String genre) {
    switch (genre) {
      case "Action":
        return AppLocalizations.of(context)!.action;
      case "Adventure":
        return AppLocalizations.of(context)!.adventure;
      case "Animation":
        return AppLocalizations.of(context)!.animation;
      case "Biography":
        return AppLocalizations.of(context)!.biography;
      case "Comedy":
        return AppLocalizations.of(context)!.comedy;
      case "Crime":
        return AppLocalizations.of(context)!.crime;
      case "Documentary":
        return AppLocalizations.of(context)!.documentary;
      case "Drama":
        return AppLocalizations.of(context)!.drama;
      case "Family":
        return AppLocalizations.of(context)!.family;
      case "Fantasy":
        return AppLocalizations.of(context)!.fantasy;
      case "Film-Noir":
        return AppLocalizations.of(context)!.film_Noir;
      case "History":
        return AppLocalizations.of(context)!.history;
      case "Horror":
        return AppLocalizations.of(context)!.horror;
      case "Music":
        return AppLocalizations.of(context)!.music;
      case "Musical":
        return AppLocalizations.of(context)!.musical;
      case "Mystery":
        return AppLocalizations.of(context)!.mystery;
      case "Romance":
        return AppLocalizations.of(context)!.romance;
      case "Sci-Fi":
        return AppLocalizations.of(context)!.sci_Fi;
      case "Sport":
        return AppLocalizations.of(context)!.sport;
      case "Thriller":
        return AppLocalizations.of(context)!.thriller;
      case "War":
        return AppLocalizations.of(context)!.war;
      case "Western":
        return AppLocalizations.of(context)!.western;
      default:
        return genre;
    }
  }
}
