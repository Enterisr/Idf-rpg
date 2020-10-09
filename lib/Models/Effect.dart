class Effect {
  int wassahEffect;
  int cashEffect;
  int respectEffect;
  int tashEffect;
  int pazamEffect;
  factory Effect.fromJson({Map<String, dynamic> effectMap}) {
    return Effect(
        wassahEffect: effectMap["w"] ?? 0,
        cashEffect: effectMap["c"] ?? 0,
        respectEffect: effectMap["r"] ?? 0,
        tashEffect: effectMap["t"] ?? 0,
        pazamEffect: effectMap["p"] ?? 1);
  }
  factory Effect.fromBlank() {
    return Effect(
        wassahEffect: 100,
        tashEffect: 100,
        cashEffect: 100,
        respectEffect: 100,
        pazamEffect: 1);
  }
  Map<String, dynamic> toJson() {
    return {
      "r": this.respectEffect,
      "c": this.cashEffect,
      "w": this.wassahEffect,
      "t": this.tashEffect,
      "p": this.pazamEffect
    };
  }

  Effect(
      {int wassahEffect,
      int cashEffect,
      int respectEffect,
      int pazamEffect,
      int tashEffect}) {
    this.wassahEffect = (wassahEffect);
    this.cashEffect = (cashEffect);
    this.respectEffect = (respectEffect);
    this.pazamEffect = (pazamEffect);
    this.tashEffect = tashEffect;
  }

  bool isContainsNegativeStat() {
    return this.cashEffect < 0 || this.respectEffect < 0 || this.tashEffect < 0;
  }

  void addEffect(Effect newEffect) {
    this.cashEffect = this.cashEffect + newEffect.cashEffect;
    this.wassahEffect = this.wassahEffect + newEffect.wassahEffect;
    this.respectEffect = this.respectEffect + newEffect.respectEffect;
    this.pazamEffect = this.pazamEffect + newEffect.pazamEffect;
    this.tashEffect = this.tashEffect + newEffect.tashEffect;
  }
}
