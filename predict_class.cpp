/* --------------------------------------------------------------------------------------- */
//   Copyright 2014 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Author: Dave Rich @dave_59
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
/* --------------------------------------------------------------------------------------- */

#include "vpi_user.h"       // use vpi_printf so all output goes to transcript
#include "predict.hpp"
#include <string>
using namespace std                                                                         ;

class   CL_PREDICT {
  int ina, inb                                                                              ;
  const string m_name                                                                       ;
public:
    CL_PREDICT(string name) : m_name(name) {}
    void  set_values (int,int)                                                              ;
    int   do_predict () {return ina+inb;}
    const char* name () {return m_name.c_str();}
}                                                                                           ;

void CL_PREDICT::set_values (int x, int y) {
    ina   = x                                                                               ;
    inb   = y                                                                               ;
}



void* cl_predict_new(const char* name) {
    return (void*)( new CL_PREDICT(name) )                                                  ;
}

int cl_predict_set_values_handle(int x, int y, void* handle) {
    CL_PREDICT* r = static_cast<CL_PREDICT *>(handle)                                       ;
    r->set_values(x,y)                                                                      ;
    int out = r->do_predict()                                                               ;
    //vpi_printf("%s c++ predict: %d\n", r->name(), out)                                    ;
    return out                                                                              ;
}
