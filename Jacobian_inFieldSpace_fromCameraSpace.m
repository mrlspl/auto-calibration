function [Jacobian Point_fieldSpace] = Jacobian_inFieldSpace_fromCameraSpace(m_pos, m_rot, point)
    global focalLength opticalCenter
    
    if (min(size(focalLength)) == 0 || focalLength < 0)
        %-- f = width / (2* tan(Optical_Angle_Width / 2) )
        %-- Optical_Angle_Width = 60.97 degree (according to NAO documentation)
        focalLength = 640 / (2 * tan(1.0641 / 2));
    end
    
    if (min(size(opticalCenter)) == 0)
        opticalCenter = [320; 240];
    end
    
    r = m_pos;
    
    %-- Center Vector in Camera Coordination
    cc = [focalLength; opticalCenter - point];
    cc(2) = cc(2) * -1;
    
    %-- Center Vector in World Coordination
    cw = m_rot * cc;
    
    %-- Calculate P_FS
    Point_fieldSpace = r(1:2) - cw(1:2) * r(3) / cw(3);%[r(1) - r(3) * (cw(1) / cw(3)); r(2) - r(3) * (cw(2) / cw(3))];
    
    
    %-- Calculation of Derivatives
    cw_ux = cross([1 0 0], cc);
    cw_uy = cross([0 1 0], cc);
    cw_uz = cross([0 0 1], cc);
    
    %-- Calculation of Jacobian
    d_pfs_rx = [1; 0];
    d_pfs_ry = [0; 1];
    d_pfs_rz = [-cw(1) / cw(3); -cw(2) / cw(3)];
    
    d_pfs_ux = [(r(3) * cw(1) / cw(3)^2) * (cw_ux(3)); (-r(3) / cw(3)^2) * (cw_ux(2) * cw(3) - cw_ux(3) * cw(2))];
    d_pfs_uy = [(-r(3) / cw(3)^2) * (cw_uy(1) * cw(3) - cw_uy(3) * cw(1)); (r(3) * cw(2) / cw(3)^2) * (cw_uy(3))];
    d_pfs_uz = [(-r(3) / cw(3)) * cw_uz(1); (-r(3) / cw(3)) * cw_uz(2)];
    
    Jacobian = [d_pfs_rx d_pfs_ry d_pfs_rz d_pfs_ux d_pfs_uy d_pfs_uz];
end