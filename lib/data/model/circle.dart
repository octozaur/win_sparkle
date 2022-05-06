class Circle{
  Circle(this.size, this.x, this.y, [this.step = 0.5]);

  late double size;
  late double x;
  late double y;
  double step;

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