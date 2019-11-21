import 'dart:math';

///比例增益控制加速度计/磁强计的收敛速度
var kp = 100.0;
///积分增益控制陀螺偏差的收敛速度
var ki = 0.002;
///传感器框架相对于辅助框架的四元数(初始化四元数的值)
var halfT = 0.001;

///传感器框架相对于辅助框架的四元数(初始化四元数的值)
var q0 = 1.0;
var q1 = 0.0;
var q2 = 0.0;
var q3 = 0.0;

///由Ki缩放的积分误差项(初始化)
var exInt = 0;
var eyInt = 0;
var ezInt = 0;

updateIMU(ax,ay,az,gx,gy,gz){

  ///测量正常化
  var norm = sqrt((ax*ax)+(ay*ay)+(az*az));

  ///单元化
  ax = ax/norm;
  ay = ay/norm;
  az = az/norm;

  ///估计方向的重力
  var vx = 2*(q1*q3 - q0*q2);
  var vy = 2*(q0*q1 + q2*q3);
  var vz = q0*q0 - q1*q1 - q2*q2 + q3*q3;

  ///错误的领域和方向传感器测量参考方向之间的交叉乘积的总和
  var ex = (ay*vz - az*vy);
  var ey = (az*vx - ax*vz);
  var ez = (ax*vy - ay*vx);

  ///积分误差比列积分增益
  exInt += ex*ki;
  eyInt += ey*ki;
  ezInt += ez*ki;

  ///调整后的陀螺仪测量
    gx += kp*ex + exInt;
    gy += kp*ey + eyInt;
    gz += kp*ez + ezInt;
    
  ///整合四元数
    q0 += (-q1*gx - q2*gy - q3*gz)*halfT;
    q1 += (q0*gx + q2*gz - q3*gy)*halfT;
    q2 += (q0*gy - q1*gz + q3*gx)*halfT;
    q3 += (q0*gz + q1*gy - q2*gx)*halfT;
    
  ///正常化四元数
    norm = sqrt(q0*q0 + q1*q1 + q2*q2 + q3*q3);
    q0 /= norm;
    q1 /= norm;
    q2 /= norm;
    q3 /= norm;

  ///获取欧拉角 pitch、roll、yaw
    var pitch = asin(-2*q1*q3+2*q0*q2)*57.3;
    var roll = atan2(2*q2*q3+2*q0*q1,-2*q1*q1-2*q2*q2+1)*57.3;
    var yaw = atan2(2*(q1*q2 + q0*q3),q0*q0+q1*q1-q2*q2-q3*q3)*57.3;
    return [pitch,roll,yaw];
}




