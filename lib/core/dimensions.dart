import 'dart:math';

import 'package:flutter/material.dart';

class Dims {
  const Dims._();
  static Size designSize = const Size(430, 932);
  static late Size deviceSize;

  static void setSize(MediaQueryData media) {
    deviceSize = Size(
      media.size.width,
      media.size.height,
    );
  }

  // naive implementation
  static double quotient(double dim1, double dim2) {
    return dim1 > dim2 ? dim1 / dim2 : dim2 / dim1;
  }

  @Deprecated(
    'use [this.dx] || [this.dxPercent], [this.dy] || [this.dyPercent] or [this.sp]',
  )
  // naive implementation, use [this.dx], [this.dy] or [this.sp] instead
  static double space(double x) {
    final deviceRatio = quotient(deviceSize.height, deviceSize.width);
    final designRatio = quotient(designSize.height, designSize.width);
    final ratio = deviceRatio / designRatio;

    return ratio * x;
  }

  // horizontal[width] quotient
  static double dxQuotient() {
    final quotient = deviceSize.width / designSize.width;

    return quotient;
  }

  // vertical[height] quotient
  static double dyQuotient() {
    final quotient = deviceSize.height / designSize.height;

    return quotient;
  }

  // give horizontal spacing in percentages in respect to device width
  static double dxPercent(num extent) {
    return deviceSize.width * extent;
  }

  // give vertical spacing in percentages in respect to device height
  static double dyPercent(num extent) {
    return deviceSize.height * extent;
  }

  // give responsive horizontal spacing [value is calculated based on device size and design size]
  static double dx(num x) {
    final quotient = dxQuotient();

    return quotient * x;
  }

  // give responsive vertical spacing [value is calculated based on device size and design size]
  static double dy(num x) {
    final quotient = dyQuotient();

    return quotient * x;
  }

  // give responsive font sizes [based on device size and design size]
  static double sp(num x) {
    final _dxQuotient = dxQuotient();
    final _dyQuotient = dyQuotient();
    final ratio = min(_dxQuotient, _dyQuotient);

    return ratio * x;
  }
}

extension DimsExtension on num {
  // horizontal spacing
  double get dx => Dims.dx(this);
  // vertical spacing
  double get dy => Dims.dy(this);
  // vertical spacing [in percentage]
  double get dyPercent => Dims.dyPercent(this);
  // horizontal spacing [in percentage]
  double get dxPercent => Dims.dxPercent(this);
  // font size
  double get sp => Dims.sp(this);
}

class SpaceX extends StatelessWidget {
  const SpaceX(this._width);

  final double _width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
    );
  }
}

class SpaceY extends StatelessWidget {
  const SpaceY(this._height);
  final double _height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
    );
  }
}