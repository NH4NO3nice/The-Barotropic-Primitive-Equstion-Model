!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!空间差分!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

MODULE module_space_integration
    contains
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!二次守恒平流方程格式!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!!!!!!!!!!!!!本子程序只计算内部网格，边界值不管，为时间积分做准备!!!!!!!!!!!!!!!!!! 
    !!!!!!!!!!!!!!!!!!!!!时间积分也只对内部网格做，边界值由边界条件得到!!!!!!!!!!!!!!!!!!!!!!!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    SUBROUTINE advection_equation_2(ub, vb, zb, m, f, E, G, H, d, nx, ny)
    ! ub, vb, zb：当前时刻的物理量                                                                                             
    ! E, G, H：预报要素的变化倾向
    ! m：地图放大系数
    ! f：地转参数
    ! nx, ny：格点数
    ! d：网格距
    ! gt：重力加速度
        IMPLICIT NONE
        INTEGER :: i, j
        INTEGER :: nx, ny
        REAL, PARAMETER :: gt = 9.8
        REAL :: ub(nx, ny), vb(nx, ny), zb(nx, ny)
        REAL :: E(nx, ny), G(nx, ny), H(nx, ny)
        REAL :: m(nx, ny), f(nx, ny)
        REAL :: d
    
        do i = 2, nx - 1
            do j = 2, ny -1
                E(i, j) = -1 * m(i, j) *((ub(i + 1, j) ** 2 - ub(i - 1, j) ** 2) / (4.0 * d)                                                                                                            &
                                                 + ((vb(i, j + 1) + vb(i, j)) * (ub(i, j + 1) - ub(i, j)) + (vb(i, j) + vb(i, j - 1)) * (ub(i, j) - ub(i, j - 1))) / (4.0 * d)      &
                                                 +  gt * (zb(i + 1, j) - zb(i - 1, j)) / (2.0 * d))                                                                                                                    &
                               + (f(i, j) + ub(i, j) * (m(i, j + 1) - m(i, j - 1)) / (2.0 * d) - vb(i, j) * (m(i + 1, j) - m(i - 1, j)) / (2.0 * d)) * vb(i, j) 
            
                G(i, j) = -1 * m(i, j) * (((ub(i + 1, j) + ub(i, j)) * (vb(i + 1, j) - vb(i, j)) + (ub(i, j) + ub(i - 1, j)) * (vb(i, j) - vb(i - 1, j))) / (4.0 * d)    &
                                                      + (vb(i, j + 1) ** 2 - vb(i, j - 1) ** 2) / (4.0 * d)                                                                                                       &
                                                      + gt * (zb(i, j + 1) - zb(i, j - 1)) / (2.0 * d))                                                                                                                &
                               - (f(i, j) + ub(i, j) * (m(i, j + 1) - m(i, j - 1)) / (2.0 * d) - vb(i, j) * (m(i + 1, j) - m(i - 1, j)) / (2.0 * d)) * ub(i, j) 
            
                H(i, j) = -1 * m(i, j) ** 2 * (((ub(i + 1, j) + ub(i, j)) * (zb(i + 1, j) / m(i + 1, j) - zb(i, j) / m(i, j))                                                              &
                                                            +  (ub(i, j) + ub(i - 1, j)) * (zb(i, j) / m(i, j) - zb(i - 1, j) / m(i - 1, j))) / (4.0 * d)                                              &
                                                            +   ((vb(i, j + 1) + vb(i, j)) * (zb(i, j + 1) / m(i, j + 1) - zb(i, j) / m(i, j))                                                           &
                                                            +   (vb(i, j) + vb(i, j - 1)) * (zb(i, j) / m(i, j) - zb(i, j -1) / m(i, j - 1))) / (4.0 * d)                                              &
                                                            + zb(i, j) / m(i, j) * (ub(i + 1, j) - ub(i - 1, j) + vb(i, j + 1) - vb(i, j - 1)) / (2.0 * d))
            enddo
        enddo
        return
    END SUBROUTINE advection_equation_2
END MODULE