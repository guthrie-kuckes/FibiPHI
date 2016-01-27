//
//  ginterface.c
//  FibiPHI
//
//  Created by GK on 1/17/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//

#include <stdio.h>

#include "ginterface.h" 

void initRational(mpq_t rational) {
    
    mpq_init(rational);
}

void deinitRational(mpq_t rational) {
    
    mpq_clear(rational);
}

void setIntValue(mpq_t rational, unsigned long long value) {
    
    mpq_set_ui(rational, value, 1) ;
}


void initFloatWithValue(mpf_t floating, double value) {
    
    printf("passed double was %f\n", value);
    mpf_init(floating);
    mpf_set_d(floating, value);
}

void deinitFloat(mpf_t floating) {
    
    mpf_clear(floating);
}

void setFloatValue(mpf_t floating, double value) {
    
    mpf_set_d(floating, value);

}

char* getFloatDescription(mpf_t floating) {
    
    //mp_set_memory_functions(malloc, realloc, free);
    
    char** deposit = malloc(sizeof(char*));
    int success = gmp_asprintf(deposit, "%.20Ff", floating);
    printf("description was %s, with succcess %d\n", *deposit, success);
    //mpf_out_str(stdout, 10, 0, floating);
    
    char* good = *deposit;
    free(deposit);
    
    return good;
}

mpf_t* memory() {
    
    mpf_t* allocated = malloc(sizeof(mpf_t));
    return allocated;
}