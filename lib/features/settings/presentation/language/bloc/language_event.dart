import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;
  const ChangeLanguageEvent(this.locale);

  @override
  List<Object> get props => [locale];
}
