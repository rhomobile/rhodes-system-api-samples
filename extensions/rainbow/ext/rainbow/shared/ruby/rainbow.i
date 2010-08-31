/* rainbow.i */
%module Rainbow
%{
extern void rainbow_open_native_view();
extern void rainbow_close_native_view();
extern void rainbow_execute_command_in_native_view(const char* command);
#define open_native_view rainbow_open_native_view 
#define close_native_view rainbow_close_native_view
#define execute_command_in_native_view rainbow_execute_command_in_native_view 
%}

extern void open_native_view();
extern void close_native_view();
extern void execute_command_in_native_view(const char* command);
