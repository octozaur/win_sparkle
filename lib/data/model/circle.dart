class Circle{
  Circle(this.size, this.x, this.y);

  late double size;
  late double x;
  late double y;
  double step = 0.5;

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