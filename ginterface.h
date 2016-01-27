//
//  ginterface.h
//  FibiPHI
//
//  Created by GK on 1/17/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//

#ifndef ginterface_h
#define ginterface_h


#include <stdio.h>
#include <gmp.h>
#include <stdlib.h>


void initRational(mpq_t rational);

void deinitRational(mpq_t rational);

void setIntValue(mpq_t rational, unsigned long long value);



void initFloatWithValue(mpf_t floating, double value);

void deinitFloat(mpf_t floating);

void setFloatValue(mpf_t floating, double value);

char* getFloatDescription(mpf_t floating);

mpf_t* memory();



#endif /* ginterface_h */
