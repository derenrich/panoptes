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

#include <boost/static_assert.hpp>
#include <cuda.h>
#include <gtest/gtest.h>
#include <stdint.h>
#include <valgrind/memcheck.h>
#include <cstdio>

extern "C" __global__ void k_minmax(const int * data, const int N,
        int * min_value, int * max_value) {
    int local_max = INT_MIN;
    int local_min = INT_MAX;

    for (int idx = threadIdx.x + blockDim.x * blockIdx.x;
            idx < N; idx += blockDim.x * gridDim.x) {
        const int d = data[idx];

        local_max = max(local_max, d);
        local_min = min(local_min, d);
    }

    max_value[blockIdx.x] = local_max;
    min_value[blockIdx.x] = local_min;
}

TEST(kNOOP, ExplicitStream) {
    cudaError_t ret;
    cudaStream_t stream;

    const int N = 1 << 20;
    const int n_blocks = 32;

    int * data;
    int * max_values;
    int * min_values;

    ret = cudaMalloc((void **) &data, sizeof(*data) * N);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaMalloc((void **) &max_values, n_blocks);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaMalloc((void **) &min_values, n_blocks);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaStreamCreate(&stream);
    ASSERT_EQ(cudaSuccess, ret);

    k_minmax<<<256, n_blocks, 0, stream>>>(data, N, max_values, min_values);

    ret = cudaStreamSynchronize(stream);
    EXPECT_EQ(cudaSuccess, ret);

    ret = cudaStreamDestroy(stream);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaFree(data);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaFree(max_values);
    ASSERT_EQ(cudaSuccess, ret);

    ret = cudaFree(min_values);
    ASSERT_EQ(cudaSuccess, ret);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
