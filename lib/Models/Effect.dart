class Effect {
  int wassahEffect;
  int cashEffect;
  int respectEffet;
  Effect({int wassahEffect, int cashEffect, int respectEffect}) {
    this.wassahEffect = (wassahEffect);
    this.cashEffect = (cashEffect);
    this.respectEffet = (respectEffect);
  }

  void addEffect(Effect newEffect) {
    this.cashEffect = this.cashEffect + newEffect.cashEffect;
    this.wassahEffect = this.wassahEffect + newEffect.wassahEffect;
    this.respectEffet = this.respectEffet + newEffect.respectEffet;
  }
}
