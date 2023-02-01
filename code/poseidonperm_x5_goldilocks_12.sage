#!/usr/bin/env sage

t = 12
R_F = 8
R_P = 22
prime = 0xffffffff00000001
n = len(format(prime, 'b'))
F = GF(prime)

round_constants = [
    [0x13dcf33aba214f46, 0x30b3b654a1da6d83, 0x1fc634ada6159b56, 0x937459964dc03466, 0xedd2ef2ca7949924, 0xede9affde0e22f68, 0x8515b9d6bac9282d, 0x6b5c07b4e9e900d8, 0x1ec66368838c8a08, 0x9042367d80d1fbab, 0x400283564a3c3799, 0x4a00be0466bca75e],
    [0x7913beee58e3817f, 0xf545e88532237d90, 0x22f8cb8736042005, 0x6f04990e247a2623, 0xfe22e87ba37c38cd, 0xd20e32c85ffe2815, 0x117227674048fe73, 0x4e9fb7ea98a6b145, 0xe0866c232b8af08b, 0x00bbc77916884964, 0x7031c0fb990d7116, 0x240a9e87cf35108f],
    [0x2e6363a5a12244b3, 0x5e1c3787d1b5011c, 0x4132660e2a196e8b, 0x3a013b648d3d4327, 0xf79839f49888ea43, 0xfe85658ebafe1439, 0xb6889825a14240bd, 0x578453605541382b, 0x4508cda8f6b63ce9, 0x9c3ef35848684c91, 0x0812bde23c87178c, 0xfe49638f7f722c14],
    [0x8e3f688ce885cbf5, 0xb8e110acf746a87d, 0xb4b2e8973a6dabef, 0x9e714c5da3d462ec, 0x6438f9033d3d0c15, 0x24312f7cf1a27199, 0x23f843bb47acbf71, 0x9183f11a34be9f01, 0x839062fbb9d45dbf, 0x24b56e7e6c2e43fa, 0xe1683da61c962a72, 0xa95c63971a19bfa7],
    [0x4adf842aa75d4316, 0xf8fbb871aa4ab4eb, 0x68e85b6eb2dd6aeb, 0x07a0b06b2d270380, 0xd94e0228bd282de4, 0x8bdd91d3250c5278, 0x209c68b88bba778f, 0xb5e18cdab77f3877, 0xb296a3e808da93fa, 0x8370ecbda11a327e, 0x3f9075283775dad8, 0xb78095bb23c6aa84],
    [0x3f36b9fe72ad4e5f, 0x69bc96780b10b553, 0x3f1d341f2eb7b881, 0x4e939e9815838818, 0xda366b3ae2a31604, 0xbc89db1e7287d509, 0x6102f411f9ef5659, 0x58725c5e7ac1f0ab, 0x0df5856c798883e7, 0xf7bb62a8da4c961b, 0xc68be7c94882a24d, 0xaf996d5d5cdaedd9],
    [0x9717f025e7daf6a5, 0x6436679e6e7216f4, 0x8a223d99047af267, 0xbb512e35a133ba9a, 0xfbbf44097671aa03, 0xf04058ebf6811e61, 0x5cca84703fac7ffb, 0x9b55c7945de6469f, 0x8e05bf09808e934f, 0x2ea900de876307d7, 0x7748fff2b38dfb89, 0x6b99a676dd3b5d81],
    [0xac4bb7c627cf7c13, 0xadb6ebe5e9e2f5ba, 0x2d33378cafa24ae3, 0x1e5b73807543f8c2, 0x09208814bfebb10f, 0x782e64b6bb5b93dd, 0xadd5a48eac90b50f, 0xadd4c54c736ea4b1, 0xd58dbb86ed817fd8, 0x6d5ed1a533f34ddd, 0x28686aa3e36b7cb9, 0x591abd3476689f36],
    [0x047d766678f13875, 0xa2a11112625f5b49, 0x21fd10a3f8304958, 0xf9b40711443b0280, 0xd2697eb8b2bde88e, 0x3493790b51731b3f, 0x11caf9dd73764023, 0x7acfb8f72878164e, 0x744ec4db23cefc26, 0x1e00e58f422c6340, 0x21dd28d906a62dda, 0xf32a46ab5f465b5f],
    [0xbfce13201f3f7e6b, 0xf30d2e7adb5304e2, 0xecdf4ee4abad48e9, 0xf94e82182d395019, 0x4ee52e3744d887c5, 0xa1341c7cac0083b2, 0x2302fb26c30c834a, 0xaea3c587273bf7d3, 0xf798e24961823ec7, 0x962deba3e9a2cd94, 0xb36ee79485ca4707, 0xd380199eddd2de52],
    [0x70971fc4e6f85305, 0x8e722f6e5dc32699, 0xa0883df133052b92, 0x8f86c6a3eb7d01a4, 0x763649c8b670bdc5, 0x830d5c82b808759b, 0xaa1da8bb91da02e7, 0x9bc9bf629e211c4d, 0x0f0a899b10a4dea8, 0xb883bdcee7c6b356, 0x78c7101e7496ae1e, 0x2fd6c5a8bf1e5ca6],
    [0xe2a6e06e61fcec9c, 0xebfce7d5c5b3dbd5, 0xca2eeca4bb485d85, 0xc2b875537c42eb69, 0x6faf849976873328, 0xfc3fcb6e81ad4cc3, 0x180dd95503955a28, 0xd40f19a3c9fe1520, 0x49d178ddbf7fd96d, 0x3950bee2e10e0297, 0x437b90cf295be062, 0xa5cd126edffad23b],
    [0xdf58134c134491c2, 0x0677eca229d9f7bd, 0x492200a1f7d83a3c, 0xafb58c9810a43645, 0x7659077c5a9c208e, 0x30b4bc83706995cd, 0xc98fa77bbbef3a3b, 0x84a82905750b3109, 0x72f2a02326aeb69b, 0x8d27a2a2d73a848a, 0xaa9e30a80bde4b68, 0x63abb1415e050474],
    [0x1c4bd1e816050a7e, 0x15d1502e4f469dfd, 0x53989d594b0c4cd8, 0x7a1a4c83cb7e377e, 0x1b52f8a9944e480e, 0xeb7b03f76a91a79e, 0x0073a4fc9328c69e, 0x2c7b16f8620d9de4, 0x950d052963e46bc4, 0x8d201ba1a9c89fac, 0xd3502941bdf35503, 0x7c6dfcd5af8676fb],
    [0xf8a6cd02e92cdb0b, 0x6e7500f3a5464b22, 0x07637eabba4bdd20, 0x88b82717beee0e14, 0xbaa2b1cd3dd4c79a, 0xdfecc3aebec4cfa6, 0x7561087b0cff0166, 0x538fcac317a703a6, 0xd7d6c6eeeeeeea19, 0xd647b1ee441658a0, 0xdf4442110236c546, 0x559ef2c6dd73ec15],
    [0x4c0f5fc6c0dda3d1, 0x685010cc3100cea7, 0x2fb6ba8aa0344440, 0xb515f0a3ca75f1fb, 0x886887eaecb87c10, 0xf03ec3fd710abb04, 0xd3b4763e17f543ef, 0x50d9e5716e78083a, 0x0bce2385cf8d74ff, 0xaf23032cd5f0e04b, 0xd366aa112b6159d9, 0x810a3ad3ac7979db],
    [0x0a4a11d794be40a2, 0xeebf0cf23b668a3f, 0x600873fb011d761b, 0x0bfb5591a02ff618, 0xa16e2a528910af52, 0xf6553653e2878421, 0xccbe7c7a601a30c0, 0xb18b214fe489f5b3, 0xe21017ab9e153425, 0x586099ede17af9a6, 0x385078b514f50647, 0xc02b3a9afb89883d],
    [0x6d3fbd3b4a9f1de6, 0x4b4d40a41b0f473c, 0x838f1887b8f31711, 0x9396895be5c58a41, 0x6247a479d66fc2e3, 0x13fe228a98f2d0a2, 0x5ba5fde765f9481e, 0xafb89fa62267e117, 0xfa4dc1bebcaa6333, 0xdbab590882b87289, 0xc3b6c08e23ba9301, 0xd84b5de94a324fb7],
    [0x0d0c371c5b35b850, 0x7964f570e7188038, 0x5daf18bbd996604c, 0x6743bc47b9595258, 0x5528b9362c59bb71, 0xac45e25b7127b68c, 0xa2077d7dfbb606b6, 0xf3faac6faee378af, 0x0c6388b51545e884, 0xd27dbb6944917b61, 0x89bcac584344c104, 0x856bab802ce7402d],
    [0x2cff3000be1fcd0a, 0x765f2977fa72a917, 0x1443711329f5f9d5, 0xd35cd0261af2f951, 0x2a1bb986084ec281, 0x2334a54b758f23f2, 0xa9b8cb612caf706b, 0xb6ba11c4ab1a1017, 0xde96b0824b4b46e2, 0xc59d4272c6d92e2c, 0x389bb5107611754d, 0x23647fbc77657372],
    [0xd5ef60d6f76a42fa, 0xebb406bb79ac9819, 0x55faccc709a2f423, 0xd9d6ea97490091cd, 0xef3ce5069647a7e4, 0xdf31625d3fa78464, 0x242e60fd68f10f66, 0x39c966cc815f084d, 0x20e2e22e02bae3f7, 0xb38919d3f1173d7c, 0xf17769f6c77084d9, 0xcc051d8094cac41f],
    [0x942069f5d6eece7e, 0x8d61d3e6f141c572, 0xc5cef9d85dd605f4, 0x938f2ac2bf885997, 0x23bddbace7c48f6c, 0xc90a6c5ba98537e4, 0x0be6ee2cca90f6ae, 0xa026175394ae0e90, 0x29fca3e314c77628, 0x2aa2aa8738ab7b77, 0xe11bbd31fbb8cac6, 0xb5bbbef1b78a23af],
    [0x8b62a5551e9a9797, 0x3f91073d4d491c80, 0x4cfa44976396424a, 0xf8dcb2dfb3aa1b44, 0x3849409eba1a95f5, 0x070845799f234380, 0x184c0093667da1ba, 0xbd66aafccd51601e, 0xee6d14e92155b490, 0x626f2ec1865bc544, 0x1bd2854bf6485986, 0x368b8497472f12ef],
    [0x4f88cdcdfb791921, 0xe2c0acfeda9ae781, 0x9739bc21773469b3, 0x00ce3ad64dc4bb8f, 0xaab85a321ee7a4c8, 0xd5de825be97004f4, 0x48d676d3a043b1c6, 0x9c6180b1ff643097, 0x34882a89dd590b09, 0xae7e6b0d249c3b1d, 0x8c016908a04885a1, 0x83ebaaebc9ae0721],
    [0xab21b42e0f642307, 0xdb46631f62bb29c1, 0xef29f0399e09b5d9, 0x5b52fbb3613b8ba1, 0x57e129fcc96922e6, 0xcdeb14c9d9204b3a, 0x1341ef0da8536e34, 0xd7e3400f2bacde63, 0x6911eeb42f70d7e5, 0xc3a2a910a4679767, 0x1773cbe4a0f6bb28, 0xe17b0d53e843eab5],
    [0x587fa39990b62800, 0x0d5d32788135879d, 0x277f7b31fd3a4cdb, 0xa435290ee56d7efa, 0xea6f40be35159925, 0xcb73377a506171cb, 0xe43c367ce731d82a, 0x6eb305031ca10c43, 0xc019a8c622cc84cb, 0xd5614f5658c612e6, 0x7b1ecbe957c3ff98, 0x60db6ee9651a8478],
    [0x9271d450fc9b4117, 0xcffeea06b6e3aac1, 0xfa4a44c748d1cd8e, 0xe64db01ba569b469, 0xd31005160e4045fe, 0x39e0fa013e025f79, 0xe243be574196a956, 0x205b2a681e3d2642, 0x79cae5ad93486bab, 0xfdf567844e32c295, 0x331679589bfb7189, 0xaf06ee32297b89c2],
    [0xa6bcae311e498491, 0x9d16f52c96ac8b3e, 0x48a674b59393fa35, 0x0f9e65da3fde3796, 0x1e098310fc84578c, 0x559ae5fab1ae8dad, 0x56bd4d624078881d, 0xfd8bbbf8fbe817b5, 0x82d30695c44df534, 0x3ec0a97bc41127c5, 0x1eb8b64adaa22078, 0x82c45e418d60c983],
    [0xb092280f484d55bf, 0xcd317c9537697939, 0xd3be2e352feb79f3, 0xca6d866539a390e5, 0xb5efb1a494e55ee6, 0xfa9013ac89756e9e, 0xaeb88efd1e981242, 0x13ee477cdab6e0dc, 0xce7df902c40da2d3, 0xf3fbaf0d4e6f5f34, 0xf96354ada6785f38, 0x13b5692812406886],
    [0xf03cae030a0f4418, 0x7d3172887aa98e1a, 0x8a2c2644f2faf7b9, 0x80d721abee696d00, 0x27c8b903a4d68267, 0xaf0b7b12f90291b8, 0x00acd08cfdff3817, 0x4659ee496c634328, 0xf5b25c10730dbff1, 0xdde3a153297329c2, 0x50c0b70d6910a44b, 0x23c7426af725a6a0],
]

MDS_matrix = [
    [0x5edfe0e0ee54d262, 0x624371bc65182b55, 0x44e1c8237dd3dc06, 0xda0cf25ae6bb0f9c, 0xc455b0be3ca0a96a, 0x2bfb87370e055816, 0x24f77c7114e6f0e8, 0xcc4310ce1eb234db, 0x998e97e695205e36, 0x4ba95d8cc8c2dd51, 0xa0a7f3078ca27b87, 0x3aeb23cbb7227668],
    [0x91c07f33dbe00bd4, 0x0cbb9a143dd07f96, 0xaa1cd08b5c5a4b3b, 0x593a19b825d33a34, 0xae29134c4a5241d7, 0x30bc6110b547bcb2, 0x301c833088ebd99d, 0x8a2cd6eb514a76fe, 0x29787906d8eec9e2, 0xfac3a35433b89e03, 0xf3a1981fd8a20390, 0xe9bcc7b25ffc2183],
    [0xa571559a3b2df304, 0x2805def5e3d15be6, 0x0d85adac9567c42f, 0x488be5452bc5c533, 0x180d0ba1537a0cce, 0x0c0684955b99736c, 0x235fc0da0852e6c5, 0x40cde26c7c8aa17a, 0x90516d2c28f974f5, 0x284e3f213eda8f89, 0xc1501a80bf1351f7, 0xb4f722703f374e25],
    [0x7afc7d2697af03e6, 0x73d7a571a0c9fb02, 0xf08996c9bde33fe9, 0x12aa8fbb4b328604, 0x6e884b3eca1ff4a3, 0x220cc9279345c454, 0x9ca3cdb820ba6f3d, 0xcc24eacd3fa757e1, 0x2e7e433433d14233, 0xe5cdb9c1062a1d59, 0x36c8410db97c27e3, 0xe37cc2305fbec87a],
    [0x64b67be3f72cac27, 0x85cc7807d95176dd, 0xedfb469f17605f4e, 0x411cd9cb246364d1, 0xb040817468b042dc, 0x92385d76a0e5ab5f, 0x0e4ff960302b24c4, 0x3626486ea1065efc, 0x5c0700a38840ed3f, 0x92381e8893539667, 0x0cb2b039e650b71f, 0x1eb2b9012f0d400d],
    [0x4a1c4549fefa34eb, 0x3948bd7de7751bb9, 0xd035f9576520082e, 0x9f32ebc831dcb7f1, 0xb67cea4ad9f11385, 0x840e6c8281a0c27c, 0x5454f722f2bf00c5, 0x3a392c72fd3d5b5f, 0x0418b935bbd415b8, 0xf117261a2cf511a8, 0xd8ea43cef0c62a9d, 0x62935318e54db7a3],
    [0xd587a63d34d044eb, 0x6a2d20e50e86be46, 0x4ece57d27b6fe8a3, 0x43123edb20be262e, 0x6169fd0d03bdfd81, 0xaacf3da21c652e30, 0x8e4bab30eb1b5340, 0x7d4e00557ed3cf45, 0x8668c6642d90333a, 0x20528265d027e99d, 0xd886353e659b8198, 0xb60a3732f925b1c9],
    [0x8869cb71ce6a0a84, 0xfa28a5df236b23f5, 0x8c0bc97a3ed9fb2d, 0x1239aa0190349285, 0x21416d8f72577cc9, 0x0e00627de5bbe120, 0x7890f22c2a9df9ba, 0x612cd88289783247, 0x0d555dc76c824424, 0xfd4e35856e474020, 0xcc3063d676a2b929, 0x071592c5823197cb],
    [0x2a1dc43ff0ece4a3, 0xa2e34a76bdfd6acb, 0x00eab713ddad455e, 0x351da35b36b4d7af, 0xb2b9bd8215872942, 0x5a44d716ec19c4a8, 0x15566dc388c7319d, 0xe18c9c70f4208cc9, 0xa6c6e743f3c13a0d, 0x1b81cbe6678f220f, 0x08417e4c5f16035a, 0xc30fd7b0565f0937],
    [0x6881e6a041db0140, 0xf3c66715ea7d1050, 0x83a551e0a2919d2c, 0xc58a5d1d41cf1c46, 0x1d9f8276752e573d, 0x55ec9c529ec37fa7, 0xbf941c9ad7a2d72d, 0x9c4cb0cabc41e7e4, 0xdce508990b34d822, 0x240151082123ede8, 0xea835529969ac12e, 0x2be1f782c232bf60],
    [0x8dd544aa5dfdb4b1, 0x400b7791d74b7eb1, 0x18d264a0fe5b594c, 0xedc95404deeed9b7, 0xa0759544e681bca7, 0x350652c1f58c8724, 0xb99ea14799c94ca7, 0x2637821cd6d29648, 0x60662d5bc7e75048, 0x8551f1d7e201719e, 0xc7032b641288988d, 0xbefad1556311a038],
    [0xc2ceeaff45af4b7f, 0xa1d1db7824dde727, 0xa2eadd7285f24fe6, 0x53531a3df9417c04, 0xe03ff695dc234f93, 0x55ab2ee8d1978944, 0x859dcc779fa7af37, 0x191f857546dafbb8, 0xb51ee3b9b1e6401a, 0xbd876d54e932a7fd, 0xad03f507638699c6, 0x7a3747e4492d24e7],
]

MDS_matrix_field = matrix(F, t, t)
for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(MDS_matrix[i][j])
round_constants_field = []
for i in range(0, R_F + R_P):
    for j in range(0, t):
        round_constants_field.append(F(round_constants[i][j]))

#MDS_matrix_field = MDS_matrix_field.transpose() # QUICK FIX TO CHANGE MATRIX MUL ORDER (BOTH M AND M^T ARE SECURE HERE!)

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

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        for i in range(0, t):
            state_words[i] = (state_words[i])^5
        state_words = list(MDS_matrix_field * vector(state_words))

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        state_words[0] = (state_words[0])^5
        state_words = list(MDS_matrix_field * vector(state_words))

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field[round_constants_counter]
            round_constants_counter += 1
        for i in range(0, t):
            state_words[i] = (state_words[i])^5
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

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
