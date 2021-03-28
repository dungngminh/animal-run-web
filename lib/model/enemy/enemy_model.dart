class EnemyModel {
  final String imgSrc;
  final int textureWidth;
  final int textureHeight;
  final int nColumns;
  final int nRows;
  final double timeSet;
  final bool canFly;
  final double speed;

  const EnemyModel(this.imgSrc, this.textureWidth, this.textureHeight,
      this.nColumns, this.nRows, this.timeSet, this.speed, this.canFly);
}
