class Dot{
  Dot(this.x, this.y, this.maxRefreshValue, [this.size = 1]);
  bool isActive = true;
  int refreshCount = 0;
  int maxRefreshValue = 500;
  double x;
  double y;
  double size;

  void incrementRefreshCount(){
    if(refreshCount < maxRefreshValue){
      refreshCount++;
    }else{
      refreshCount = 0;
      isActive = true;
    }
  }

  void setIsActiveFalse(){
    isActive = false;
  }
}