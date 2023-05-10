import time

N = 768
t = 12
R_F = 8
R_P = 22
prime = 0xffffffff00000001
n = len(format(prime, 'b'))
F = GF(prime)

PRINTER = True

timer_start = 0
timer_end = 0

round_constants = ['0x2e6363a5a12244b3', '0x5e1c3787d1b5011c', '0x4132660e2a196e8b', '0x3a013b648d3d4327', '0xf79839f49888ea43', '0xfe85658ebafe1439', '0xb6889825a14240bd', '0x578453605541382b', '0x4508cda8f6b63ce9', '0x9c3ef35848684c91', '0x0812bde23c87178c', '0xfe49638f7f722c14', '0x8e3f688ce885cbf5', '0xb8e110acf746a87d', '0xb4b2e8973a6dabef', '0x9e714c5da3d462ec', '0x6438f9033d3d0c15', '0x24312f7cf1a27199', '0x23f843bb47acbf71', '0x9183f11a34be9f01', '0x839062fbb9d45dbf', '0x24b56e7e6c2e43fa', '0xe1683da61c962a72', '0xa95c63971a19bfa7', '0x4adf842aa75d4316', '0xf8fbb871aa4ab4eb', '0x68e85b6eb2dd6aeb', '0x07a0b06b2d270380', '0xd94e0228bd282de4', '0x8bdd91d3250c5278', '0x209c68b88bba778f', '0xb5e18cdab77f3877', '0xb296a3e808da93fa', '0x8370ecbda11a327e', '0x3f9075283775dad8', '0xb78095bb23c6aa84', '0x3f36b9fe72ad4e5f', '0x69bc96780b10b553', '0x3f1d341f2eb7b881', '0x4e939e9815838818', '0xda366b3ae2a31604', '0xbc89db1e7287d509', '0x6102f411f9ef5659', '0x58725c5e7ac1f0ab', '0x0df5856c798883e7', '0xf7bb62a8da4c961b', '0xc68be7c94882a24d', '0xaf996d5d5cdaedd9', '0x9717f025e7daf6a5', '0x6436679e6e7216f4', '0x8a223d99047af267', '0xbb512e35a133ba9a', '0xfbbf44097671aa03', '0xf04058ebf6811e61', '0x5cca84703fac7ffb', '0x9b55c7945de6469f', '0x8e05bf09808e934f', '0x2ea900de876307d7', '0x7748fff2b38dfb89', '0x6b99a676dd3b5d81', '0xac4bb7c627cf7c13', '0xadb6ebe5e9e2f5ba', '0x2d33378cafa24ae3', '0x1e5b73807543f8c2', '0x09208814bfebb10f', '0x782e64b6bb5b93dd', '0xadd5a48eac90b50f', '0xadd4c54c736ea4b1', '0xd58dbb86ed817fd8', '0x6d5ed1a533f34ddd', '0x28686aa3e36b7cb9', '0x591abd3476689f36', '0x047d766678f13875', '0xa2a11112625f5b49', '0x21fd10a3f8304958', '0xf9b40711443b0280', '0xd2697eb8b2bde88e', '0x3493790b51731b3f', '0x11caf9dd73764023', '0x7acfb8f72878164e', '0x744ec4db23cefc26', '0x1e00e58f422c6340', '0x21dd28d906a62dda', '0xf32a46ab5f465b5f', '0xbfce13201f3f7e6b', '0xf30d2e7adb5304e2', '0xecdf4ee4abad48e9', '0xf94e82182d395019', '0x4ee52e3744d887c5', '0xa1341c7cac0083b2', '0x2302fb26c30c834a', '0xaea3c587273bf7d3', '0xf798e24961823ec7', '0x962deba3e9a2cd94', '0xb36ee79485ca4707', '0xd380199eddd2de52', '0x70971fc4e6f85305', '0x8e722f6e5dc32699', '0xa0883df133052b92', '0x8f86c6a3eb7d01a4', '0x763649c8b670bdc5', '0x830d5c82b808759b', '0xaa1da8bb91da02e7', '0x9bc9bf629e211c4d', '0x0f0a899b10a4dea8', '0xb883bdcee7c6b356', '0x78c7101e7496ae1e', '0x2fd6c5a8bf1e5ca6', '0xe2a6e06e61fcec9c', '0xebfce7d5c5b3dbd5', '0xca2eeca4bb485d85', '0xc2b875537c42eb69', '0x6faf849976873328', '0xfc3fcb6e81ad4cc3', '0x180dd95503955a28', '0xd40f19a3c9fe1520', '0x49d178ddbf7fd96d', '0x3950bee2e10e0297', '0x437b90cf295be062', '0xa5cd126edffad23b', '0xdf58134c134491c2', '0x0677eca229d9f7bd', '0x492200a1f7d83a3c', '0xafb58c9810a43645', '0x7659077c5a9c208e', '0x30b4bc83706995cd', '0xc98fa77bbbef3a3b', '0x84a82905750b3109', '0x72f2a02326aeb69b', '0x8d27a2a2d73a848a', '0xaa9e30a80bde4b68', '0x63abb1415e050474', '0x1c4bd1e816050a7e', '0x15d1502e4f469dfd', '0x53989d594b0c4cd8', '0x7a1a4c83cb7e377e', '0x1b52f8a9944e480e', '0xeb7b03f76a91a79e', '0x0073a4fc9328c69e', '0x2c7b16f8620d9de4', '0x950d052963e46bc4', '0x8d201ba1a9c89fac', '0xd3502941bdf35503', '0x7c6dfcd5af8676fb', '0xf8a6cd02e92cdb0b', '0x6e7500f3a5464b22', '0x07637eabba4bdd20', '0x88b82717beee0e14', '0xbaa2b1cd3dd4c79a', '0xdfecc3aebec4cfa6', '0x7561087b0cff0166', '0x538fcac317a703a6', '0xd7d6c6eeeeeeea19', '0xd647b1ee441658a0', '0xdf4442110236c546', '0x559ef2c6dd73ec15', '0x4c0f5fc6c0dda3d1', '0x685010cc3100cea7', '0x2fb6ba8aa0344440', '0xb515f0a3ca75f1fb', '0x886887eaecb87c10', '0xf03ec3fd710abb04', '0xd3b4763e17f543ef', '0x50d9e5716e78083a', '0x0bce2385cf8d74ff', '0xaf23032cd5f0e04b', '0xd366aa112b6159d9', '0x810a3ad3ac7979db', '0x0a4a11d794be40a2', '0xeebf0cf23b668a3f', '0x600873fb011d761b', '0x0bfb5591a02ff618', '0xa16e2a528910af52', '0xf6553653e2878421', '0xccbe7c7a601a30c0', '0xb18b214fe489f5b3', '0xe21017ab9e153425', '0x586099ede17af9a6', '0x385078b514f50647', '0xc02b3a9afb89883d', '0x6d3fbd3b4a9f1de6', '0x4b4d40a41b0f473c', '0x838f1887b8f31711', '0x9396895be5c58a41', '0x6247a479d66fc2e3', '0x13fe228a98f2d0a2', '0x5ba5fde765f9481e', '0xafb89fa62267e117', '0xfa4dc1bebcaa6333', '0xdbab590882b87289', '0xc3b6c08e23ba9301', '0xd84b5de94a324fb7', '0x0d0c371c5b35b850', '0x7964f570e7188038', '0x5daf18bbd996604c', '0x6743bc47b9595258', '0x5528b9362c59bb71', '0xac45e25b7127b68c', '0xa2077d7dfbb606b6', '0xf3faac6faee378af', '0x0c6388b51545e884', '0xd27dbb6944917b61', '0x89bcac584344c104', '0x856bab802ce7402d', '0x2cff3000be1fcd0a', '0x765f2977fa72a917', '0x1443711329f5f9d5', '0xd35cd0261af2f951', '0x2a1bb986084ec281', '0x2334a54b758f23f2', '0xa9b8cb612caf706b', '0xb6ba11c4ab1a1017', '0xde96b0824b4b46e2', '0xc59d4272c6d92e2c', '0x389bb5107611754d', '0x23647fbc77657372', '0xd5ef60d6f76a42fa', '0xebb406bb79ac9819', '0x55faccc709a2f423', '0xd9d6ea97490091cd', '0xef3ce5069647a7e4', '0xdf31625d3fa78464', '0x242e60fd68f10f66', '0x39c966cc815f084d', '0x20e2e22e02bae3f7', '0xb38919d3f1173d7c', '0xf17769f6c77084d9', '0xcc051d8094cac41f', '0x942069f5d6eece7e', '0x8d61d3e6f141c572', '0xc5cef9d85dd605f4', '0x938f2ac2bf885997', '0x23bddbace7c48f6c', '0xc90a6c5ba98537e4', '0x0be6ee2cca90f6ae', '0xa026175394ae0e90', '0x29fca3e314c77628', '0x2aa2aa8738ab7b77', '0xe11bbd31fbb8cac6', '0xb5bbbef1b78a23af', '0x8b62a5551e9a9797', '0x3f91073d4d491c80', '0x4cfa44976396424a', '0xf8dcb2dfb3aa1b44', '0x3849409eba1a95f5', '0x070845799f234380', '0x184c0093667da1ba', '0xbd66aafccd51601e', '0xee6d14e92155b490', '0x626f2ec1865bc544', '0x1bd2854bf6485986', '0x368b8497472f12ef', '0x4f88cdcdfb791921', '0xe2c0acfeda9ae781', '0x9739bc21773469b3', '0x00ce3ad64dc4bb8f', '0xaab85a321ee7a4c8', '0xd5de825be97004f4', '0x48d676d3a043b1c6', '0x9c6180b1ff643097', '0x34882a89dd590b09', '0xae7e6b0d249c3b1d', '0x8c016908a04885a1', '0x83ebaaebc9ae0721', '0xab21b42e0f642307', '0xdb46631f62bb29c1', '0xef29f0399e09b5d9', '0x5b52fbb3613b8ba1', '0x57e129fcc96922e6', '0xcdeb14c9d9204b3a', '0x1341ef0da8536e34', '0xd7e3400f2bacde63', '0x6911eeb42f70d7e5', '0xc3a2a910a4679767', '0x1773cbe4a0f6bb28', '0xe17b0d53e843eab5', '0x587fa39990b62800', '0x0d5d32788135879d', '0x277f7b31fd3a4cdb', '0xa435290ee56d7efa', '0xea6f40be35159925', '0xcb73377a506171cb', '0xe43c367ce731d82a', '0x6eb305031ca10c43', '0xc019a8c622cc84cb', '0xd5614f5658c612e6', '0x7b1ecbe957c3ff98', '0x60db6ee9651a8478', '0x9271d450fc9b4117', '0xcffeea06b6e3aac1', '0xfa4a44c748d1cd8e', '0xe64db01ba569b469', '0xd31005160e4045fe', '0x39e0fa013e025f79', '0xe243be574196a956', '0x205b2a681e3d2642', '0x79cae5ad93486bab', '0xfdf567844e32c295', '0x331679589bfb7189', '0xaf06ee32297b89c2', '0xa6bcae311e498491', '0x9d16f52c96ac8b3e', '0x48a674b59393fa35', '0x0f9e65da3fde3796', '0x1e098310fc84578c', '0x559ae5fab1ae8dad', '0x56bd4d624078881d', '0xfd8bbbf8fbe817b5', '0x82d30695c44df534', '0x3ec0a97bc41127c5', '0x1eb8b64adaa22078', '0x82c45e418d60c983', '0xb092280f484d55bf', '0xcd317c9537697939', '0xd3be2e352feb79f3', '0xca6d866539a390e5', '0xb5efb1a494e55ee6', '0xfa9013ac89756e9e', '0xaeb88efd1e981242', '0x13ee477cdab6e0dc', '0xce7df902c40da2d3', '0xf3fbaf0d4e6f5f34', '0xf96354ada6785f38', '0x13b5692812406886', '0xf03cae030a0f4418', '0x7d3172887aa98e1a', '0x8a2c2644f2faf7b9', '0x80d721abee696d00', '0x27c8b903a4d68267', '0xaf0b7b12f90291b8', '0x00acd08cfdff3817', '0x4659ee496c634328', '0xf5b25c10730dbff1', '0xdde3a153297329c2', '0x50c0b70d6910a44b', '0x23c7426af725a6a0', '0xbf3904ed0413b551', '0x82e3d89a0c303306', '0xe850568eb531d745', '0xd0e4621770ae5eab', '0xa3acdcf56d0b97e4', '0xac2f9edfd64d4b61', '0xe8c583ddde3499cb', '0x6b08988e46985490', '0x19824eafc5e886be', '0xd015026071453f3f', '0x14ef763be431b880', '0xc4a0a27a07b87898', '0x4bd7eec003a69254', '0x47917468d558fcf5', '0x5918e7f480464a14', '0xe2a483080f0f6de2', '0xcf69b23cc1db334d', '0x92e492ba22fc0066', '0xec9d8a6d9ca98846', '0xd33344db2579d4b4', '0x6fd1ad41ccb217b5', '0xbac1b3aaefb705c2', '0xb1b7da260f175329', '0x3b1efc45c55af374']

MDS_matrix = [
    ['0x6fe33ca466bf379d', '0xcfa357c1bf16d285', '0xc34b5a82d7756285', '0x34edb0a8b4baee68', '0x24f14bb7b643a82b', '0x2af255dd0d81681a', '0x3731851549ec1058', '0xc15eba47f747d402', '0xc4ec45f764e07192', '0x3fb168f42925569e', '0x93e3e226505eade7', '0x3c64af131bf33c4f'],
    ['0x325d98fa3064eda6', '0x4c65d6156dcee454', '0x934b058feb713ea8', '0x1b327a164fe70c03', '0x6906a927d801627e', '0x25ee0811957dd519', '0x3c45ccc87d07c403', '0xefab99492c47a7a3', '0x34143d057a4c262c', '0x4686b679f9136658', '0x700a1ad3fac6c8ea', '0xc1aea7019f64a380'],
    ['0x587cc99f6d745265', '0xb0d67298baa9b9a1', '0xcd06848829898cb5', '0xcde96bc9203f8c53', '0xe8a3679b9076d205', '0x931572edd6e252f3', '0xe0994114af7d0089', '0xbd0a6f9ee0da7fad', '0x3bbf4bb18dbebb7c', '0x6d595a5035501c45', '0xc2f23bcbf908da98', '0x258ba7548b5871bb'],
    ['0xd436bae94d6ad6a2', '0xb81a6580bf34fe3e', '0x6cb48f0777443181', '0x1cb1bb05f14727c8', '0x8953f9304dd9895f', '0x8daf9ce49e734a12', '0x79c2a2c2e04c67d4', '0xb743dd9cd8b7adbc', '0x6cc577a2349f26a3', '0x58ee843d090313a7', '0xdbb1a405180ff977', '0xd05aac46865a96f7'],
    ['0x3aba9cb0b43ae99a', '0x83a94da15fa4df9c', '0x8d77d755ad821512', '0xc138376b14709e7b', '0xf52b444d20888be4', '0x973a65cc70f1ee32', '0xe36747c7861b4002', '0x0ee2753760f9d7b4', '0x543c9798ed08dc13', '0x7b4243b0fcf61169', '0x512f76a0cec9ceb4', '0x60d31f3bd034797e'],
    ['0x3a10dd4cd584281f', '0x32800976cc08fbd1', '0xef3f453cd20f02af', '0xb173446eccce120e', '0x56cdbc5eadc1be8a', '0x169d782241984c24', '0x5c9b798dd2c4b908', '0x5a6e2db68066863d', '0xeabe458c64023457', '0x3dc1e785f2bb2620', '0x554c62558d9ad271', '0xa95b34acea292e5f'],
    ['0x2fd99195a7cb348f', '0xcbfbdec4a8b034aa', '0x66f1537d97c53535', '0x6ab45f2823321a72', '0x1c47d2f74483f0e3', '0xf9f833a2948ef1e6', '0x8ca5d79417d2ed42', '0xf58231458770d841', '0xfc775159ffe4d265', '0x5795b4b4d6a827c4', '0xcc666894c31af9f9', '0xa64e8a466e587c52'],
    ['0x23aa5b8f9aedb67a', '0x6931cb9374334781', '0x0e651a43ccecaf7c', '0x776fdeb9ecd9e69a', '0xcba5aa3125ecdb6a', '0xf2ec9b449465f4e6', '0x710d67b849d892a1', '0x84a440c10396bf0d', '0x0bcd58571623d345', '0xa51f215b838f0ecd', '0x6bf51ec9db36fe6f', '0x7cd68ff831b26392'],
    ['0x693762a20eb639eb', '0xcaa1633b1d289587', '0x29de4efda6149ff0', '0x61839f16a536e85d', '0x02baaa0f4f656654', '0xa9ea71b4e9b456cf', '0x5645e6bbe62b9abd', '0x1cc45154cf48ec7a', '0xbcd008e4bdb32847', '0xa3f9cb90708e66d9', '0x836290d486c3ec07', '0xdb7287d4046ca2fb'],
    ['0x3be794a38f6c5d3f', '0x427d129db96b2d3e', '0x0fe5b3eb335b5236', '0x3b77dd93bebe5d7d', '0x7e86537e410d7f38', '0x7da79f55331e44c0', '0xef166522aad66ffa', '0x99cda3700ef03e1a', '0xe698d4f66217a0fa', '0xabbb81632732cb72', '0x870b76641b339add', '0x2143ba9dd0c4f5b4'],
    ['0xe0d77ee111602d62', '0x01bd5fa760624b9a', '0xdbb233bb085d3cc0', '0x91e0c973caf45ea7', '0x92b39636773baa21', '0x44df8af3de1e567f', '0x7df473331b84d329', '0xaa0f4af4185e41a8', '0xb2e5ec5748800438', '0xed3b8b735fd292bf', '0x5cefc309ecc7f0ad', '0xd54760371e577e8d'],
    ['0x47560c5c9294954f', '0xb17a6df2bb89581f', '0xea6b0181e831acd0', '0xb449ec8d97becabd', '0x7597a12d2e5d7204', '0x4efc2f3cfa945998', '0xe38d4a07e11e4049', '0xc280de5b513cb0da', '0x12586a2968a177db', '0xadf551a4349df3ca', '0x2ca60c04d74775f5', '0xd2cef1b962c8e741'],
]
MDS_matrix_field = matrix(F, t, t)

for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(int(MDS_matrix[i][j], 16))
round_constants_field = []
for i in range(0, (R_F + R_P) * t):
    round_constants_field.append(F(int(round_constants[i], 16)))

def print_words_to_hex(words):
    hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
    print(["{0:#0{1}x}".format(int(entry), hex_length) for entry in words])

def print_concat_words_to_large(words):
    hex_length = int(ceil(float(n) / 4))
    nums = ["{0:0{1}x}".format(int(entry), hex_length) for entry in words]
    final_string = "0x" + ''.join(nums)
    print(final_string)

def calc_equivalent_constants(constants):
    constants_temp = [constants[index:index+t] for index in range(0, len(constants), t)]

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    # Start moving round constants up
    # Calculate c_i' = M^(-1) * c_(i+1)
    # Split c_i': Add c_i'[0] AFTER the S-box, add the rest to c_i
    # I.e.: Store c_i'[0] for each of the partial rounds, and make c_i = c_i + c_i' (where now c_i'[0] = 0)
    num_rounds = R_F + R_P
    R_f = R_F / 2
    for i in range(num_rounds - 2 - R_f, R_f - 1, -1):
        inv_cip1 = list(vector(constants_temp[i+1]) * MDS_matrix_field_transpose.inverse())
        constants_temp[i] = list(vector(constants_temp[i]) + vector([0] + inv_cip1[1:]))
        constants_temp[i+1] = [inv_cip1[0]] + [0] * (t-1)

    return constants_temp

def calc_equivalent_matrices():
    # Following idea: Split M into M' * M'', where M'' is "cheap" and M' can move before the partial nonlinear layer
    # The "previous" matrix layer is then M * M'. Due to the construction of M', the M[0,0] and v values will be the same for the new M' (and I also, obviously)
    # Thus: Compute the matrices, store the w_hat and v_hat values

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    w_hat_collection = []
    v_collection = []
    v = MDS_matrix_field_transpose[[0], list(range(1,t))]
    # print "M:", MDS_matrix_field_transpose
    # print "v:", v
    M_mul = MDS_matrix_field_transpose
    M_i = matrix(F, t, t)
    for i in range(R_P - 1, -1, -1):
        M_hat = M_mul[list(range(1,t)), list(range(1,t))]
        w = M_mul[list(range(1,t)), [0]]
        v = M_mul[[0], list(range(1,t))]
        v_collection.append(v.list())
        w_hat = M_hat.inverse() * w
        w_hat_collection.append(w_hat.list())

        # Generate new M_i, and multiplication M * M_i for "previous" round
        M_i = matrix.identity(t)
        M_i[list(range(1,t)), list(range(1,t))] = M_hat

        test_mat = matrix(F, t, t)
        test_mat[[0], list(range(0, t))] = MDS_matrix_field_transpose[[0], list(range(0, t))]
        test_mat[[0], list(range(1, t))] = v
        test_mat[list(range(1, t)), [0]] = w_hat
        test_mat[list(range(1,t)), list(range(1,t))] = matrix.identity(t-1)

        M_mul = MDS_matrix_field_transpose * M_i

    return [M_i, v_collection, w_hat_collection, MDS_matrix_field_transpose[0, 0]]

def cheap_matrix_mul(state_words, v, w_hat, M_0_0):
    state_words_new = [0] * t

    column_1 = [M_0_0] + w_hat
    state_words_new[0] = sum([column_1[i] * state_words[i] for i in range(0, t)])
    mul_row = [(state_words[0] * v[i]) for i in range(0, t-1)]
    add_row = [(mul_row[i] + state_words[i+1]) for i in range(0, t-1)]
    state_words_new = [state_words_new[0]] + add_row

    return state_words_new

def perm(input_words):
    round_constants_field_new = calc_equivalent_constants(round_constants_field)
    [M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()
    
    global timer_start, timer_end

    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    # Initial constants addition
    for i in range(0, t):
        state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
    # First full matrix multiplication
    state_words = list(vector(state_words) * M_i)
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        #state_words = list(vector(state_words) * M_i)
        state_words[0] = (state_words[0])**7
        # Moved constants addition
        if r < (R_P - 1):
            round_constants_round_counter += 1
            state_words[0] = state_words[0] + round_constants_field_new[round_constants_round_counter][0]
        # Optimized multiplication with cheap matrices
        state_words = cheap_matrix_mul(state_words, v_collection[R_P - r - 1], w_hat_collection[R_P - r - 1], M_0_0)
    round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    timer_end = time.time()
    
    return state_words

def perm_original(input_words):
    round_constants_field_new = [round_constants_field[index:index+t] for index in range(0, len(round_constants_field), t)]

    global timer_start, timer_end
    
    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        state_words[0] = (state_words[0])**7
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])**7
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1
    
    timer_end = time.time()

    return state_words

input_words = []
for i in range(0, t):
    input_words.append(F(i))

output_words = None
num_iterations = 10
total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm_original(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for unoptimized:", average_time)

# print "Input:"
# print_words_to_hex(input_words)
# print "Output:"
# print_words_to_hex(output_words)

print("Input (concat):")
print_concat_words_to_large(input_words)
print("Output (concat):")
print_concat_words_to_large(output_words)

total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for optimized:", average_time)

# print "Input:"
# print_words_to_hex(input_words)
# print "Output:"
# print_words_to_hex(output_words)

print("Input (concat):")
print_concat_words_to_large(input_words)
print("Output (concat):")
print_concat_words_to_large(output_words)