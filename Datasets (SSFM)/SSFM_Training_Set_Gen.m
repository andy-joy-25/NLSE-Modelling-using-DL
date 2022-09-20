T_0_all = [2e-12:0.5e-12:5e-12];
beta2_all = [-15e-27:-0.5e-27:-20e-27];
A_eff_all = [10e-12:5e-12:20e-12];

N = 8192;

ctr = 2;

for i = 1:length(T_0_all)
    for j = 1:length(beta2_all)
        for k = 1:length(A_eff_all)
            T_0 = T_0_all(i);
            T_max = 100*T_0;
            beta2 = beta2_all(j);
            
            dt = (2*T_max)/N;
            t = (-N/2:N/2-1)*dt;
            dw = pi/T_max;
            w = fftshift(-N/2:N/2-1)*dw;

            P_0 = 1;
            A = sqrt(P_0)*exp(-(t.^2)/(2*(T_0^2)));
            Ai = A;
            
            dz = 0.01; %Step size
            z = 10; %Total fiber length
            n_total = round(z/dz); %Total number of steps

            D = 1i*0.5*beta2*(w.^2);

            lambda = 1550e-9;
            c = 3e8;
            w0 = (2*pi*c)/lambda;
            A_eff = A_eff_all(k);
            n2 = 2.6e-20;
            gamma = (w0*n2)/(c*A_eff);
            Nm = 1i*gamma;
            
            for k = 1:n_total
                A = fftshift(ifft(A));
                A = A.*exp(0.5*dz*D);
                A = fft(fftshift(A));
                A = A.*exp(dz*Nm*(abs(A).^2));
                A = fftshift(ifft(A));
                A = A.*exp(0.5*dz*D);
                A = fft(fftshift(A));
            end
            
            P_out = abs(A).^2;
            P_out_save = P_out(4096:2:4224);
            
            P_in = abs(Ai).^2;
            P_in_save = P_in(4096:2:4224);
            
            cellr1 = sprintf('A%d:A%d',[ctr,ctr]);
            cellr2 = sprintf('B%d:B%d',[ctr,ctr]);
            cellr3 = sprintf('C%d:C%d',[ctr,ctr]);
            cellr4 = sprintf('D%d:BP%d',[ctr,ctr]);
            cellr5 = sprintf('A%d:BM%d',[ctr,ctr]);
            
            xlswrite("D:\PHN-319\Input_Data_New_PHN-319.xlsx",T_0,cellr1);
            xlswrite("D:\PHN-319\Input_Data_New_PHN-319.xlsx",beta2,cellr2);
            xlswrite("D:\PHN-319\Input_Data_New_PHN-319.xlsx",A_eff,cellr3);
            xlswrite("D:\PHN-319\Input_Data_New_PHN-319.xlsx",P_in_save,cellr4);
            xlswrite("D:\PHN-319\Output_Data_New_PHN-319.xlsx",P_out_save,cellr5);
            
            ctr = ctr + 1;
        end
    end
end


