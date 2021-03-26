function [] = daq_therm()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cleanupObj = onCleanup(@cleanMeUp);

%visaObj = visa('keysight', 'TCPIP0::192.168.1.239::inst0::INSTR');
visaObj = visa('keysight', 'USB0::0x2A8D::0x5101::MY58000924::0::INSTR');

visaObj.InputBufferSize=100000;
visaObj.Timeout=10;
visaObj.ByteOrder='littleEndian';
fopen(visaObj);
fprintf(visaObj, '*IDN?');
idn = fscanf(visaObj)
fprintf(visaObj, 'TRIG:SOUR IMM');

colors=['k', 'r', 'b', 'y', 'g', 'm'];
%brown = rgb('brown');


for i=1:300
  fprintf(visaObj, 'INIT');
  fprintf(visaObj, 'FETC?');
  res=fscanf(visaObj);
  thermstr=split(res, ',');
  
  if i==1
    therm=str2double(thermstr);
    timeseries=now;
    h=plot(timeseries, therm');
    datetick('x', 'HH:MM:SS');
    xlabel('Time');
    ylabel('Temperature (deg C)');
  else
    therm=[therm, str2double(thermstr)];
    timeseries=[timeseries, now];
    if 1 %mod(i,3)==0
        h=plot(timeseries, therm', 'LineWidth', 8);
        set(h, {'color'}, { [0.6 0.3 0.0]; [1.0 0.2 0.2]; [1.0 0.6 0.2]; [0.9 0.9 0.2]    });
        datetick('x', 'HH:MM:SS');
        xlabel('Time');
        ylabel('Temperature (deg C)');
    end
  end
  fprintf(visaObj, 'OUTP:ALAR1:SET');
  pause(2.0);
end % end for loop


function cleanMeUp()
    fclose(visaObj);
    delete(visaObj);
    clear visaObj;
end % end function cleanMeUp()



end % end of main function

