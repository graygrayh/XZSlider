# XZSlider
可调节大小的滑动条

使用方法：

1.创建控件或拖入xib布局Class改为XZSlider  
2.slider.values = [0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0]  //可调节的数值，按一定顺序排列   
3.slider.defaultValue = 1.0 //默认值  
4.slider.changeActionComplete = { //每次调节完成的回调
(index,value) in
}  

