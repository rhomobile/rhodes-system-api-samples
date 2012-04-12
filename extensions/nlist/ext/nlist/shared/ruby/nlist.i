/* nlist.i */
%module NList
%{
#include "ruby/ext/rho/rhoruby.h"

extern void nlist_open_list(rho_param* params_hash, const char* callback);
extern void nlist_close_list();


#define open_list nlist_open_list 
#define close_list nlist_close_list 

%}

%typemap(in) (rho_param *params_hash) {
  $1 = rho_param_fromvalue($input);
}

%typemap(freearg) (rho_param *params_hash) {
  rho_param_free($1);
}


extern void open_list(rho_param* params_hash, const char* callback);
extern void close_list();
