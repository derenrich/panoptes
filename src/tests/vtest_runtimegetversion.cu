/**
 * Panoptes - A Binary Translation Framework for CUDA
 * (c) 2011-2012 Chris Kennelly <chris@ckennelly.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <boost/scoped_array.hpp>
#include <boost/static_assert.hpp>
#include <cuda.h>
#include <gtest/gtest.h>
#include <stdint.h>
#include <valgrind/memcheck.h>
#include <cstdio>

TEST(RuntimeGetVersion, Null) {
    cudaError_t ret;

    ret = cudaRuntimeGetVersion(NULL);
    EXPECT_EQ(cudaErrorInvalidValue, ret);
}

TEST(RuntimeGetVersion, NonNull) {
    cudaError_t ret;
    int runtimeVersion;

    ret = cudaRuntimeGetVersion(&runtimeVersion);
    EXPECT_EQ(cudaSuccess, ret);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
