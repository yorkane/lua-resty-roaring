/**
orcli ffi /code/CRoaring/luac.cpp Roaring64Map luac.so
/usr/local/openresty/nginx/
**/

#include <cstring>
#include <cassert>
#include <iostream>
#include <roaring/roaring.hh>
#include <xxhash.h>
using namespace roaring;

/**
g++ -I include/ -I cpp/ -I src/ -O3 -g -Wall -Wextra -Wno-return-local-addr
-fpic -std=c++11 -Wl,rpath=/usr/local/openresty/nginx/lib -c luac.cpp
g++ luac.o xxhash.o -shared -o luac.so && mv luac.so
/usr/local/openresty/site/lualib/ -f
**/
/* orcli ffi /code/CRoaring/luac.cpp Roaring64Map luac.so
 * /usr/local/openresty/nginx/
 */

// g++ -I include/ -I cpp/ -I src/ -O3 -g -Wall -Wextra -fpic -std=c++11
// -Wl,rpath=/usr/local/openresty/nginx/lib -c luac.cpp
/*included xxhash version*/
// g++ luac.o xxhash.o -shared -o luac.so && mv luac.so
// /usr/local/openresty/site/lualib/ -f
/*linked xxhash version*/
// g++ luac.o -shared -o luac.so -L/usr/lib64/ -lxxhash && mv luac.so
// /usr/local/openresty/site/lualib/ -f
extern "C" {
bool r32_load_from_bytes(Roaring *self, const char *bytes) {
  Roaring p;
  try {
    p = Roaring::read(bytes);
    roaring_bitmap_or_inplace(&self->roaring, &p.roaring);
    return true;
  } catch (const std::exception &e) {
    return false;
  }
}

bool r64_load_from_bytes(Roaring64Map *self, const char *bytes) {
  Roaring64Map p;
  try {
    p = Roaring64Map::read(bytes);
    *self = *self | p;
    return true;
  } catch (const std::exception &e) {
    return false;
  }
}

void *new_Roaring64Map(const char *bytes) {
  Roaring64Map *po = new Roaring64Map;
  if (bytes != NULL) {
    if (!r64_load_from_bytes(po, bytes)) {
    }
  }
  return reinterpret_cast<void *>(po);
}

void *new_Roaring(const char *bytes) {
  Roaring *po = new Roaring;
  if (bytes != NULL) {
    r32_load_from_bytes(po, bytes);
  }
  return reinterpret_cast<void *>(po);
}

void delete_Roaring64Map(Roaring64Map *self) {
  // r64_bitmap_free(self);
  delete self;
}

void delete_Roaring(Roaring *self) {
  // r64_bitmap_free(self);
//  ra_clear(&self->roaring.high_low_container);
//  free(self->roaring);
  delete self;
}

void r64_add_uint64(Roaring64Map *self, uint64_t num) {
  self->add(num);
  return;
}

void r32_add_uint(Roaring *self, uint32_t num) {
  self->add(num);
  return;
}

void r32_add_bytes(Roaring *self, const char *bytes) {
  uint32_t num;
  memcpy(&num, bytes, 4);
  self->add(num);
  return;
}

void r64_add_bytes(Roaring64Map *self, const char *bytes) {
  uint64_t num;
  memcpy(&num, bytes, 8);
  self->add(num);
  return;
}

void *r64_bitmapOf(Roaring64Map *self, int64_t n1, int64_t n2, int64_t n3,
                   int64_t n4, int64_t n5, int64_t n6, int64_t n7, int64_t n8,
                   int64_t n9, int64_t n10) {
  if (self == NULL) {
    self = new Roaring64Map;
  }
  if (n1 > 0) {
    self->add((uint64_t)n1);
  } else if (n1 < 0) {
    self->remove((uint64_t)abs(n1));
  }
  if (n2 > 0) {
    self->add((uint64_t)n2);
  } else if (n2 < 0) {
    self->remove((uint64_t)abs(n2));
  }
  if (n3 > 0) {
    self->add((uint64_t)n3);
  } else if (n3 < 0) {
    self->remove((uint64_t)abs(n3));
  }
  if (n4 > 0) {
    self->add((uint64_t)n4);
  } else if (n4 < 0) {
    self->remove((uint64_t)abs(n4));
  }
  if (n5 > 0) {
    self->add((uint64_t)n5);
  } else if (n5 < 0) {
    self->remove((uint64_t)abs(n5));
  }
  if (n6 > 0) {
    self->add((uint64_t)n6);
  } else if (n6 < 0) {
    self->remove((uint64_t)abs(n6));
  }
  if (n7 > 0) {
    self->add((uint64_t)n7);
  } else if (n7 < 0) {
    self->remove((uint64_t)abs(n7));
  }
  if (n8 > 0) {
    self->add((uint64_t)n8);
  } else if (n8 < 0) {
    self->remove((uint64_t)abs(n8));
  }
  if (n9 > 0) {
    self->add((uint64_t)n9);
  } else if (n9 < 0) {
    self->remove((uint64_t)abs(n9));
  }
  if (n10 > 0) {
    self->add((uint64_t)n10);
  } else if (n10 < 0) {
    self->remove((uint64_t)abs(n10));
  }
  return reinterpret_cast<void *>(self);
}

void *r32_bitmapOf(Roaring *self, int64_t n1, int64_t n2, int64_t n3,
                   int64_t n4, int64_t n5, int64_t n6, int64_t n7, int64_t n8,
                   int64_t n9, int64_t n10) {
  if (self == NULL) {
    self = new Roaring;
  }
  if (n1 > 0) {
    self->add(n1);
  } else if (n1 < 0) {
    self->remove(n1 * -1);
  }
  if (n2 > 0) {
    self->add(n2);
  } else if (n2 < 0) {
    self->remove(n2 * -1);
  }
  if (n3 > 0) {
    self->add(n3);
  } else if (n3 < 0) {
    self->remove(n3 * -1);
  }
  if (n4 > 0) {
    self->add(n4);
  } else if (n4 < 0) {
    self->remove(n4 * -1);
  }
  if (n5 > 0) {
    self->add(n5);
  } else if (n5 < 0) {
    self->remove(n5 * -1);
  }
  if (n6 > 0) {
    self->add(n6);
  } else if (n6 < 0) {
    self->remove(n6 * -1);
  }
  if (n7 > 0) {
    self->add(n7);
  } else if (n7 < 0) {
    self->remove(n7 * -1);
  }
  if (n8 > 0) {
    self->add(n8);
  } else if (n8 < 0) {
    self->remove(n8 * -1);
  }
  if (n9 > 0) {
    self->add(n9);
  } else if (n9 < 0) {
    self->remove(n9 * -1);
  }
  if (n10 > 0) {
    self->add(n10);
  } else if (n10 < 0) {
    self->remove(n10 * -1);
  }
  return reinterpret_cast<void *>(self);
}

bool r32_containsRange(Roaring *self, uint64_t x, uint64_t y) {
  return self->containsRange(x, y);
}

void r32_addRange(Roaring *self, uint64_t x, uint64_t y) {
  self->addRange(x, y);
}

void r32_removeRange(Roaring *self, uint32_t x, uint32_t y) {
  roaring_bitmap_remove_range_closed(&self->roaring, x, y);
}

void r64_remove_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self - *target;
  // delete self;
}

void r32_remove_map(Roaring *self, Roaring *target) {
  *self = *self - *target;
  // delete self;
}

void r64_add_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self | *target;
  // delete self;
}

void r32_add_map(Roaring *self, Roaring *target) {
  *self = *self | *target;
  Roaring t;
  // delete self;
}

void r64_intersect_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self & *target;
  // delete self;
}

void r32_intersect_map(Roaring *self, Roaring *target) {
  roaring_bitmap_and_inplace(&self->roaring, &target->roaring);
  // *self = *self & *target;
  // delete self;
}

void r64_andnot_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self - *target;
}

void r32_andnot_map(Roaring *self, Roaring *target) {
  roaring_bitmap_andnot_inplace(&self->roaring, &target->roaring);
}

void r64_or_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self | *target;
}

void r32_or_map(Roaring *self, Roaring *target) {
  roaring_bitmap_or_inplace(&self->roaring, &target->roaring);
}

void r64_xor_map(Roaring64Map *self, Roaring64Map *target) {
  *self = *self ^ *target;
}

void r32_xor_map(Roaring *self, Roaring *target) {
  roaring_bitmap_xor_inplace(&self->roaring, &target->roaring);
}

size_t r64_maximum(Roaring64Map *self) { return self->maximum(); }

size_t r32_maximum(Roaring *self) { return self->maximum(); }

size_t r64_minimum(Roaring64Map *self) { return self->minimum(); }

size_t r32_minimum(Roaring *self) { return self->minimum(); }

void r64_addMany(Roaring64Map *self, size_t n_args, const size_t *vals) {
  self->addMany(n_args, vals);
}

void r32_addMany(Roaring *self, size_t n_args, const uint32_t *vals) {
  self->addMany(n_args, vals);
}

bool r64_contains(Roaring64Map *self, uint64_t num) {
  return self->contains(num);
}

bool r32_contains(Roaring *self, uint64_t num) { return self->contains(num); }

bool r64_addChecked(Roaring64Map *self, size_t num) {
  return self->addChecked(num);
}

bool r32_addChecked(Roaring *self, size_t num) { return self->addChecked(num); }

uint64_t r64_add_hash(Roaring64Map *self, const char *uid, int length) {
  uint64_t num = XXH64(uid, length, 3);
  if (num != 0) {
    self->add(num);
  }
  return num;
}

uint32_t r32_add_hash(Roaring *self, const char *uid, int length) {
  uint32_t num = XXH32(uid, length, 3);
  if (num != 0) {
    self->add(num);
  }
  return num;
}

uint32_t r64_byte_size(Roaring64Map *self) {
  return self->getSizeInBytes(true);
}

uint32_t r32_byte_size(Roaring *self) { return self->getSizeInBytes(true); }

void r64_tostring(Roaring64Map *self, char *dst) {
  assert(self != NULL);
  self->write(dst, true);
}

void r32_tostring(Roaring *self, char *dst) {
  // uint32_t expectedsize = self->getSizeInBytes();
  // char* serializedbytes = new char[expectedsize];
  // self->write(serializedbytes);
  // std::cout << "tostring: " << serializedbytes << "  size:  " <<
  // expectedsize
  //           << std::endl;
  // Roaring p = Roaring::read(serializedbytes);
  // std::cout << "  size:  " << p.getSizeInBytes()
  //           << "deserialized: " << p.cardinality() << std::endl;
  assert(self != NULL);
  self->write(dst, true);
}

uint64_t r64_count(Roaring64Map *self) {
  assert(self != NULL);
  return self->cardinality();
}

uint32_t r32_count(Roaring *self) {
  assert(self != NULL);
  return self->cardinality();
}

void r64_list(Roaring64Map *self, uint64_t *num_list_buff) {
  assert(self != NULL);
  self->toUint64Array(num_list_buff);
}

void r32_list(Roaring *self, uint32_t *num_list_buff) {
  assert(self != NULL);
  self->toUint32Array(num_list_buff);
}

// void r32_list_range(Roaring *self, uint32_t *num_list_buff, size_t offset, size_t limit) {
  // assert(self != NULL);
  // self->rangeUint32Array(num_list_buff, size_t offset, size_t limit);
// }

void r64_runOptimize(Roaring64Map *self) {
  assert(self != NULL);
  self->runOptimize();
}

void r32_runOptimize(Roaring *self) {
  assert(self != NULL);
  self->runOptimize();
}

void r64_remove(Roaring64Map *self, uint64_t x) {
  assert(self != NULL);
  self->remove(x);
}

void r32_remove(Roaring *self, uint32_t x) {
  assert(self != NULL);
  self->remove(x);
}

bool r64_removeChecked(Roaring64Map *self, uint64_t x) {
  assert(self != NULL);
  return self->removeChecked(x);
}

bool r32_removeChecked(Roaring *self, uint32_t x) {
  assert(self != NULL);
  return self->removeChecked(x);
}

// void r64_union(Roaring64Map* self, Roaring64Map* source) {
//     assert(self != NULL);
//     assert(source != NULL);
//     self = self | source;
// }

// void* r32_intersect(Roaring* self, Roaring* source) {
//     assert(self != NULL);
//     assert(source != NULL);
//     roaring_bitmap_t *i1_2  = roaring_bitmap_and(self, source);
//     return reinterpret_cast<void*>(i1_2);
// }

void r64_bytes_from_uint64(uint64_t number, char *result) {
  memcpy(result, &number, 8);
}

uint64_t r64_uint64_from_byte(const char *buffer) {
  uint64_t value;
  memcpy(&value, buffer, 8);
  return value;
}

uint64_t r64_xxhash64(const char *str, size_t length, uint64_t seed,
                      char *dst_8bytes) {
  uint64_t number = XXH64(str, length, seed);
  // bytes_from_uint64(number, dst_8bytes);
  memcpy(dst_8bytes, &number, 8);
  return number;
}

uint32_t r64_xxhash32(const char *str, size_t length, uint64_t seed) {
  uint32_t number = XXH32(str, length, seed);
  // bytes_from_uint64(number, dst_8bytes);
  // memcpy(dst_4bytes, &number, 4);
  return number;
}

bool runOptimize(Roaring64Map *self) {
	return self->runOptimize();
}

size_t shrinkToFit(Roaring64Map *self) {
	return self->shrinkToFit();
}

void clear(Roaring64Map *self) {
	 self->clear();
}

}