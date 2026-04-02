#line 145 "bits.c"
int bitXor(int x, int y) {
  return ~( ~(x & ~y) & ~(~x & y));
#line 0 "<command-line>"
#include "/usr/include/stdc-predef.h"
#line 147 "bits.c"
}
#line 155
int tmin(void) {
  return 1 << 31;
}
#line 166
int isTmax(int x) {
  return !(~(x + 1) ^ x) & !!(x + 1);
}
#line 178
int allOddBits(int x) {
  int mask=  0xAA |( 0xAA << 8);
  mask = mask |( mask << 16);
  return !((x & mask) ^ mask);
}
#line 193
int negate(int x) {
  return ~x + 1;
}
#line 207
int isAsciiDigit(int x) {
  int upper_ok=  !((x >> 4) ^ 0x3);
  int lower_bits=  x & 0xF;
  int lower_ok=  !((lower_bits + 6) >> 4);
  return upper_ok & lower_ok;
}
#line 220
int conditional(int x, int y, int z) {
  int mask=  !!x;
  mask = ~mask + 1;

  return (y & mask) |( z & ~mask);
}
#line 233
int isLessOrEqual(int x, int y) {
  int diff=  y +( ~x + 1);
  int sign_diff=  diff >> 31;
  int sign_x=  x >> 31;
  int sign_y=  y >> 31;

  int signs_different=  sign_x ^ sign_y;

  int overflow_case=  sign_x & !sign_y;

  return (!signs_different & !sign_diff) | overflow_case;
}
#line 254
int logicalNeg(int x) {
  return ((x |( ~x + 1)) >> 31) + 1;
}
#line 269
int howManyBits(int x) {
  int bit16;int bit8;int bit4;int bit2;int bit1;int bit0;
  int sign=  x >> 31;
  int n=  x ^ sign;


  bit16 =( !!(n >> 16)) << 4;
  n = n >> bit16;

  bit8 =( !!(n >> 8)) << 3;
  n = n >> bit8;

  bit4 =( !!(n >> 4)) << 2;
  n = n >> bit4;

  bit2 =( !!(n >> 2)) << 1;
  n = n >> bit2;

  bit1 =( !!(n >> 1));
  n = n >> bit1;

  bit0 = n;

  return bit16 + bit8 + bit4 + bit2 + bit1 + bit0 + 1;
}
#line 306
unsigned floatScale2(unsigned uf) {
  unsigned sign=  uf & 0x80000000;
    unsigned exp=  uf & 0x7F800000;
    unsigned mantissa=  uf & 0x007FFFFF;

    if (exp == 0x7F800000) {
        return uf;
    }

    if (exp == 0) {
        mantissa <<= 1;
        if (mantissa & 0x00800000) {
            exp = 0x00800000;
            mantissa &= 0x007FFFFF;
        }
        return sign | exp | mantissa;
    }

    exp += 0x00800000;
    if (exp == 0x7F800000) {
        mantissa = 0;
    }
    return sign | exp | mantissa;
}
#line 342
int floatFloat2Int(unsigned uf) {
  int E;int mantissa;int exp;int value;
  int sign=  uf >> 31;
  exp =( uf >> 23) & 0xFF;
  mantissa = uf & 0x007FFFFF;


  if (exp == 0xFF) return 0x80000000;
  if (!exp) return 0;

  E = exp - 127;
  value = mantissa | 0x00800000;

  if (E < 0) return 0;
  if (E > 31) return 0x80000000;


  if (E < 23) {
      value >>=( 23 - E);
  } else {
    value <<=( E - 23);
  }

  return sign ? -value : value;
}
#line 380
unsigned floatPower2(int x) {
  int exp=  x + 127;


  if (exp >= 255) {
      return 0x7F800000;
  }


  if (exp >= 1) {
      return exp << 23;
  }


  if (exp >= -126) {


      int shift_amount=  x + 149;
      if (shift_amount >= 0 && shift_amount < 24) {
          return 1 << shift_amount;
      }
      return 0;
  }


  return 0;
}
