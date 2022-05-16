class Circle{
  Circle(this.size, this.x, this.y, {this.step = 0.5, this.isWhite = true});

  late double size;
  late double x;
  late double y;
  double step;
  bool isWhite;

  void reduceSize(){
    if(size - step > 0){
      size -= step;
    }else{
      size = 0;
    }
  }

  void increaseSize(double value){
    size += value;
  }
}