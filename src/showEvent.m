function evt = showEvent( source, evt )
disp('in show Event2')
disp(source)
disp('evt: ')
disp(evt)
disp(evt.getPropertyName())
disp(evt.getOldValue())
% disp(javaMethod('getOldValue',evt))

end

