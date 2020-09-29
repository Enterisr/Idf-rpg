import 'dart:convert';

class Effect {
  int wassahEffect;
  int cashEffect;
  int respectEffect;

  factory Effect.fromJson({Map<String, dynamic> effectMap}) {
    return Effect(
        wassahEffect: effectMap["w"] ?? 0,
        cashEffect: effectMap["c"] ?? 0,
        respectEffect: effectMap["r"] ?? 0);
  }
  factory Effect.fromBlank() {
    return Effect(wassahEffect: 0, cashEffect: 0, respectEffect: 0);
  }
  toJson() {
    return jsonEncode(this);
  }

  Effect({int wassahEffect, int cashEffect, int respectEffect}) {
    this.wassahEffect = (wassahEffect);
    this.cashEffect = (cashEffect);
    this.respectEffect = (respectEffect);
  }

  void addEffect(Effect newEffect) {
    this.cashEffect = this.cashEffect + newEffect.cashEffect;
    this.wassahEffect = this.wassahEffect + newEffect.wassahEffect;
    this.respectEffect = this.respectEffect + newEffect.respectEffect;
  }
}
