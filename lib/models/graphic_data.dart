import 'package:flutter/material.dart';

class GraphicData {
  int gridCount;
  List<Offset> dataDots;
  List<Offset> trendDots;
  int zoomFactorX;
  int zoomFactorY;
  double displaceX;
  double displaceY;
  double maxSize;
  double axisArrowOffset;
  String dotType;
  double dotSize;
  bool showGrid;

  GraphicData({
    this.gridCount,
    this.dataDots,
    this.trendDots,
    this.zoomFactorX,
    this.zoomFactorY,
    this.displaceX,
    this.displaceY,
    this.maxSize,
    this.axisArrowOffset: 4.0,
    this.dotType: 'circle',
    this.dotSize: 5.0,
    this.showGrid,
  });

  GraphicData cloneData() {
    return GraphicData(
      gridCount: this.gridCount,
      dataDots: this.dataDots,
      trendDots: this.trendDots,
      zoomFactorX: this.zoomFactorX,
      zoomFactorY: this.zoomFactorY,
      displaceX: this.displaceX,
      displaceY: this.displaceY,
      maxSize: this.maxSize,
      axisArrowOffset: this.axisArrowOffset,
      dotType: this.dotType,
      dotSize: this.dotSize,
      showGrid: this.showGrid,
    );
  }
}
