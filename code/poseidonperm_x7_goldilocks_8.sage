#!/usr/bin/env sage

t = 8
R_F = 8
R_P = 22
prime = 0xffffffff00000001
n = len(format(prime, 'b'))
F = GF(prime)

round_constants = [
    [0xce57d6245ddca6b2, 0xb1fc8d402bba1eb1, 0xb5c5096ca959bd04, 0x6db55cd306d31f7f, 0xc49d293a81cb9641, 0x1ce55a4fe979719f, 0xa92e60a9d178a4d1, 0x002cc64973bcfd8c],
    [0xcea721cce82fb11b, 0xe5b55eb8098ece81, 0x4e30525c6f1ddd66, 0x43c6702827070987, 0xaca68430a7b5762a, 0x3674238634df9c93, 0x88cee1c825e33433, 0xde99ae8d74b57176],
    [0x488897d85ff51f56, 0x1140737ccb162218, 0xa7eeb9215866ed35, 0x9bd2976fee49fcc9, 0xc0c8f0de580a3fcc, 0x4fb2dae6ee8fc793, 0x343a89f35f37395b, 0x223b525a77ca72c8],
    [0x56ccb62574aaa918, 0xc4d507d8027af9ed, 0xa080673cf0b7e95c, 0xf0184884eb70dcf8, 0x044f10b0cb3d5c69, 0xe9e3f7993938f186, 0x1b761c80e772f459, 0x606cec607a1b5fac],
    [0x14a0c2e1d45f03cd, 0x4eace8855398574f, 0xf905ca7103eff3e6, 0xf8c8f8d20862c059, 0xb524fe8bdd678e5a, 0xfbb7865901a1ec41, 0x014ef1197d341346, 0x9725e20825d07394],
    [0xfdb25aef2c5bae3b, 0xbe5402dc598c971e, 0x93a5711f04cdca3d, 0xc45a9a5b2f8fb97b, 0xfe8946a924933545, 0x2af997a27369091c, 0xaa62c88e0b294011, 0x058eb9d810ce9f74],
    [0xb3cb23eced349ae4, 0xa3648177a77b4a84, 0x43153d905992d95d, 0xf4e2a97cda44aa4b, 0x5baa2702b908682f, 0x082923bdf4f750d1, 0x98ae09a325893803, 0xf8a6475077968838],
    [0xceb0735bf00b2c5f, 0x0a1a5d953888e072, 0x2fcb190489f94475, 0xb5be06270dec69fc, 0x739cb934b09acf8b, 0x537750b75ec7f25b, 0xe9dd318bae1f3961, 0xf7462137299efe1a],
    [0xb1f6b8eee9adb940, 0xbdebcc8a809dfe6b, 0x40fc1f791b178113, 0x3ac1c3362d014864, 0x9a016184bdb8aeba, 0x95f2394459fbc25e, 0xe3f34a07a76a66c2, 0x8df25f9ad98b1b96],
    [0x85ffc27171439d9d, 0xddcb9a2dcfd26910, 0x26b5ba4bf3afb94e, 0xffff9cc7c7651e2f, 0x8c88364698280b55, 0xebc114167b910501, 0x2d77b4d89ecfb516, 0x332e0828eba151f2],
    [0x46fa6a6450dd4735, 0xd00db7dd92384a33, 0x5fd4fb751f3a5fc5, 0x496fb90c0bb65ea2, 0xf3baec0bb87cc5c7, 0x862a3c0a7d4c7713, 0xbf5f38336a3f47d8, 0x41ad9dbc1394a20c],
    [0xcc535945b7dbf0f7, 0x82af2bc93685bcec, 0x8e4c8d0c8cebfccd, 0x17cb39417e84597e, 0xd4a965a8c749b232, 0xa2cab040f33f3ee5, 0xa98811a1fed4e3a6, 0x1cc48b54f377e2a1],
    [0xe40cd4f6c5609a27, 0x11de79ebca97a4a4, 0x9177c73d8b7e929d, 0x2a6fe8085797e792, 0x3de6e93329f8d5ae, 0x3f7af9125da962ff, 0xd710682cfc77d3ac, 0x48faf05f3b053cf4],
    [0x287db8630da89c8b, 0x4d0de32053cb30e9, 0x8b37a4f20c5ada7b, 0xe7cc6ebe78c84ecf, 0x240bdc0a66a2610d, 0x8299e7f02caa1650, 0x380a53fefb6e754e, 0x684a1d8cf8eb6810],
    [0xe839452eb4b8a5e1, 0xb03fa62e90626af4, 0x11a688602fbc5efc, 0x30dda75c355a2d62, 0x0f712adcb73810de, 0xffdc1102187f1ae1, 0x40c34f398254b99c, 0xede021b9dc289a4a],
    [0x8b7b05225c4e7dad, 0x3bc794346f9d9ff9, 0xfccb5a57f2ca86ff, 0xbb1502015a7da9d4, 0xd7e0a35d4352a015, 0x27af7a44f8160931, 0xc37442f6782f4615, 0xbdf392a9bd095dcb],
    [0xc17f55037cf00de9, 0xbcffedd34c71a874, 0x5eb45d2a8133d1f2, 0xbabe251e1612ebdf, 0x3efeb9fbe438c536, 0x2d7cef97b4afe1cf, 0xe5de1b4660016c0b, 0xcdcc26c332f5657c],
    [0xe01dd653daf15809, 0xb0a6bdd4b41094b5, 0x27eac858b0b03a05, 0x51d43b5e93adbdc0, 0x8b89a23b0fea5fc9, 0xdc8ac3b14f7f2fc1, 0xe793f82f1efec039, 0x9f6f2cf8969e7b80],
    [0x49d45382e0f21d4a, 0x5f4ad1797cd72786, 0x4dc3dbebfd45f795, 0x03a3ef84dba6e1bc, 0x204bc9b3d3fc4c01, 0x9ad706081e89b9ba, 0x638bfb4d840e9f89, 0x5ef2938cd095ae35],
    [0x42cca18ebeb265c8, 0xb7b2ec5c29aecbf8, 0x0d84f9535dc78f0f, 0x04e64ad942e77b8c, 0xb4880dffffc9da0b, 0x16db16d9c29adeb1, 0x09bbaf2a0590cd1e, 0x76460e74961fcf8d],
    [0xed12a2276dfa1553, 0x0b5acec5de0436fd, 0x3c6cfea033a1f0a8, 0x2b5ecefe546cac15, 0x6e2d82884cd3bf6f, 0xc134878d1add7b83, 0x997963422eb7a280, 0x5e834537ac648cf6],
    [0x89e779214737c0b7, 0x1a8c05e8581ad95b, 0x8d18b72796437cf7, 0xe7252c949e04b106, 0x53267c4fd174585a, 0xa16ef5d9c81dad47, 0xda65191937270a46, 0xcb2a5b55f2df664c],
    [0x854aee2dc1924137, 0xf37013c9d479ece6, 0x0e163bc0630c4696, 0x384ee64955048f76, 0xf65d814e28ee4ec5, 0xe57bc564fd82f1b1, 0x4b338937b6876614, 0x66ee0b04ed43cd8d],
    [0x49884bf25f4ef15d, 0xeb51fe28de1c6f54, 0x2cd64e84fce8dfcc, 0x29164a96a541a013, 0x173ce7558f4cacb8, 0xeb5b1ce5877c89e9, 0x5faff4b0f5217bf6, 0xac42d0b1c20f205e],
    [0xfb1d6bf0ca43221b, 0x97b0a1b01d6a2955, 0x08c60bd622952b30, 0x43f2be0f9e24147c, 0xfa7268b7d3730f5d, 0x43a6c419a23983bb, 0xcd77c1f7b29b113c, 0xcfa43c9db8eec29f],
    [0xcaaa95a6c7365dec, 0x0a91193f798f3be0, 0x1104497652735dc6, 0x35aecb93663b515e, 0x8dbc9916065aa858, 0xada8f7a0266579ed, 0x524dee7bec1ea789, 0xa93aee9dd5af9521],
    [0x9d1f1b54750d707e, 0x7c9feab87096d5dc, 0xa2e1fb19f9d4261b, 0xb714deb448de6346, 0x225d1f0d011c5403, 0x1549b7f1d28cedc0, 0xaef3e46f97d43942, 0x6dfc7ffe0b38bf08],
    [0x7de853fdc542b663, 0xa68ecc96610657b2, 0xe88bb5428af289b1, 0xd7cfa1504c5569f5, 0x78a9aad0d642d30a, 0xd68315f2353dce52, 0x46e56300f86fcfd5, 0x323d95332b145fd6],
    [0x181cff410419105a, 0xa71cdaba74c81728, 0xe2b17550449499f0, 0x474b90c1e42ff4f7, 0x10d7671b1a0730e4, 0xd9d2b8917df231eb, 0x082a958dc0685130, 0x2d2a1e840484a8ba],
    [0x1f7f18872acb86a2, 0x8df77a3f61c156a4, 0xfc47745cc9a1cf13, 0x1d50411da002c498, 0x32aacca03ecd9219, 0x2bf13d029f679e0e, 0xf93487c503c68c68, 0x1a0cd52189236947],
]

MDS_matrix = [
    [0xd967e33c77c25e68, 0xccd9bd563753749a, 0xd36543be68eea582, 0x6432392aaa683d00, 0xe99b56ed5504766e, 0xb991728c2c4c8c8d, 0x99015b6a4f366030, 0x1d5ba183f7decbef],
    [0xcc33763d6ec46396, 0xda026dea1c51b372, 0x9e36573c8b61e478, 0x2de605271ec75cd3, 0x1cea9cc1538c5e4e, 0x1a5eedb65275b6b1, 0xeb396f271705975f, 0xa4157a3fccff6d37],
    [0xd44453fd74284107, 0xf16d14ace90919bc, 0x12a6cd158b014354, 0x207864cc65de8c78, 0x66e393d98cd60a62, 0xbbd3bea95f5f2730, 0x88754bb78e5fc6a2, 0x6cdcc14630789785],
    [0x256d6781ca55f18e, 0x159bbfd2e619cc30, 0x6626e0713cc9ae6b, 0x99bd0f9d1e23a446, 0x5bb1fc7519a59b0a, 0x4102d422be83578e, 0x4178da93c2815140, 0xdd8cd9d3cc95b91b],
    [0xf953b83f15c15223, 0xd5d2e93b526d6568, 0x0066de8c30b19bca, 0xbb0f0a33e486bb69, 0x39bdd4d839fe5b96, 0x9b73b728e94faa21, 0x7bc0490b6c7af50c, 0x62c14b9b0ee1e4f4],
    [0x80ffc532f3356729, 0x42db3624ccb2ad01, 0xe441f39a6fe29910, 0x41f818f497a04124, 0x6469d01db73de7c0, 0x680f183956b26f1f, 0x81810253c9e5be97, 0xb3b694af59eb5c1a],
    [0xd3bbb9ea06f44f01, 0x5c53f0f061645b81, 0x467f3df6a7f113f8, 0x3f27ba80777ac251, 0x143d44aa14a29e45, 0xf6ec5002e7f7c8bd, 0x5559cdcd3c8718fa, 0x1badf6decaa8e66d],
    [0x2bd4c69554cdedeb, 0xcc88207cd6da5d7c, 0x04309f5a5bf833a3, 0x81dce3538bf6f1d2, 0xafe94f259918a572, 0xad5a8de09b6b3476, 0x41a5d2e7eb140dab, 0x1cf53c5c5ce1c7ce],
]

MDS_matrix_field = matrix(F, t, t)
for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(MDS_matrix[i][j])
round_constants_field = []
for i in range(0, R_F + R_P):
    for j in range(0, t):
        round_constants_field.append(F(round_constants[i][j]))

def print_hex(c, last, rust=False):
    c = int(c)
    if rust:
        print(f"        Fp::new({c}),")
    else:
        hex_length = (n + 3)//4 + 2 # +2 for "0x"
        print("{0:#0{1}x}".format(c, hex_length), end="" if last else ", ")

def print_words_to_hex(M, rust=False):
    print("    [", end="\n" if rust else "")
    for (i, entry) in enumerate(M):
        print_hex(entry, i == len(M)-1, rust=rust)
    print("    ]," if rust else "],")


def perm(input_words):

    R_f = int(R_F / 2)

    round_constants_counter = 0

    state_words = list(input_words)
    while len(state_words) < t:
        state_words.append(0)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        state_words[0] = (state_words[0])**7
        state_words = list(MDS_matrix_field * vector(state_words))

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))

    return state_words

def main(args):
    rust = '--rust' in args

    input_words = []
    for i in range(0, t):
        input_words.append(F(i))

    output_words = perm(input_words)

    print("Input:")
    print_words_to_hex(input_words, rust=rust)
    print("Output:")
    print_words_to_hex(output_words, rust=rust)

    if rust:
        L = [[0 for i in range(4)], [1 for i in range(4)]]
        for j in range(10):
            L.append([F.random_element() for i in range(4)])
        print("input_data:")
        for l in L:
            print_words_to_hex(l, rust=rust)

        R = []
        for l in L:
            R.append(perm(l))
        print("output_data:")
        for r in R:
            print_words_to_hex(r[0:4], rust=rust)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
