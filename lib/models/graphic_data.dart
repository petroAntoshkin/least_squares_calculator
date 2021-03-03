import 'package:flutter/material.dart';

class GraphicData{
  int gridCount;
  List<Offset> dataDots;
  List<Offset> trendDots;
  int zoomFactor;
  double displaceX;
  double displaceY;
  double maxSize;
  GraphicData({
    this.gridCount,
    this.dataDots,
    this.trendDots,
    this.zoomFactor,
    this.displaceX,
    this.displaceY,
    this.maxSize
  });
}