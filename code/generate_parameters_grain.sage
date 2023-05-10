#!/usr/bin/env sage

# Remark: This script contains functionality for GF(2^n), but currently works only over GF(p)! A few small adaptations are needed for GF(2^n).
from sage.rings.polynomial.polynomial_gf2x import GF2X_BuildIrred_list

# Note that R_P is increased to the closest multiple of t
# GF(p), alpha=3, N = 1536, n = 64, t = 24, R_F = 8, R_P = 42: sage generate_parameters_grain.sage 1 0 64 24 8 42 0xfffffffffffffeff
# GF(p), alpha=5, N = 1524, n = 254, t = 6, R_F = 8, R_P = 60: sage generate_parameters_grain.sage 1 0 254 6 8 60 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
# GF(p), x^(-1), N = 1518, n = 253, t = 6, R_F = 8, R_P = 60: sage generate_parameters_grain.sage 1 1 253 6 8 60 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed

# GF(p), alpha=5, N = 765, n = 255, t = 3, R_F = 8, R_P = 57: sage generate_parameters_grain.sage 1 0 255 3 8 57 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
# GF(p), alpha=5, N = 1275, n = 255, t = 5, R_F = 8, R_P = 60: sage generate_parameters_grain.sage 1 0 255 5 8 60 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
# GF(p), alpha=5, N = 762, n = 254, t = 3, R_F = 8, R_P = 57: sage generate_parameters_grain.sage 1 0 254 3 8 57 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
# GF(p), alpha=5, N = 1270, n = 254, t = 5, R_F = 8, R_P = 60: sage generate_parameters_grain.sage 1 0 254 5 8 60 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001

FIELD = None
SBOX = None
FIELD_SIZE = None
NUM_CELLS = None
R_F_FIXED = None
R_P_FIXED = None
PRIME_NUMBER = None
F = None
INIT_SEQUENCE = None

def grain_sr_generator():
    bit_sequence = INIT_SEQUENCE
    for _ in range(0, 160):
        new_bit = bit_sequence[62] ^^ bit_sequence[51] ^^ bit_sequence[38] ^^ bit_sequence[23] ^^ bit_sequence[13] ^^ bit_sequence[0]
        bit_sequence.pop(0)
        bit_sequence.append(new_bit)
        
    while True:
        new_bit = bit_sequence[62] ^^ bit_sequence[51] ^^ bit_sequence[38] ^^ bit_sequence[23] ^^ bit_sequence[13] ^^ bit_sequence[0]
        bit_sequence.pop(0)
        bit_sequence.append(new_bit)
        while new_bit == 0:
            new_bit = bit_sequence[62] ^^ bit_sequence[51] ^^ bit_sequence[38] ^^ bit_sequence[23] ^^ bit_sequence[13] ^^ bit_sequence[0]
            bit_sequence.pop(0)
            bit_sequence.append(new_bit)
            new_bit = bit_sequence[62] ^^ bit_sequence[51] ^^ bit_sequence[38] ^^ bit_sequence[23] ^^ bit_sequence[13] ^^ bit_sequence[0]
            bit_sequence.pop(0)
            bit_sequence.append(new_bit)
        new_bit = bit_sequence[62] ^^ bit_sequence[51] ^^ bit_sequence[38] ^^ bit_sequence[23] ^^ bit_sequence[13] ^^ bit_sequence[0]
        bit_sequence.pop(0)
        bit_sequence.append(new_bit)
        yield new_bit
grain_gen = grain_sr_generator()
        
def grain_random_bits(num_bits):
    random_bits = [next(grain_gen) for i in range(0, num_bits)]
    # random_bits.reverse() ## Remove comment to start from least significant bit
    random_int = int("".join(str(i) for i in random_bits), 2)
    return random_int

def init_generator(field, sbox, n, t, R_F, R_P):
    # Generate initial sequence based on parameters
    bit_list_field = [_ for _ in (bin(FIELD)[2:].zfill(2))]
    bit_list_sbox = [_ for _ in (bin(SBOX)[2:].zfill(4))]
    bit_list_n = [_ for _ in (bin(FIELD_SIZE)[2:].zfill(12))]
    bit_list_t = [_ for _ in (bin(NUM_CELLS)[2:].zfill(12))]
    bit_list_R_F = [_ for _ in (bin(R_F)[2:].zfill(10))]
    bit_list_R_P = [_ for _ in (bin(R_P)[2:].zfill(10))]
    bit_list_1 = [1] * 30
    global INIT_SEQUENCE
    INIT_SEQUENCE = bit_list_field + bit_list_sbox + bit_list_n + bit_list_t + bit_list_R_F + bit_list_R_P + bit_list_1
    INIT_SEQUENCE = [int(_) for _ in INIT_SEQUENCE]

def generate_constants(field, n, t, R_F, R_P, prime_number):
    round_constants = []
    num_constants = (R_F + R_P) * t

    if field == 0:
        for i in range(0, num_constants):
            random_int = grain_random_bits(n)
            round_constants.append(random_int)
    elif field == 1:
        for i in range(0, num_constants):
            random_int = grain_random_bits(n)
            while random_int >= prime_number:
                # print("[Info] Round constant is not in prime field! Taking next one.")
                random_int = grain_random_bits(n)
            round_constants.append(random_int)
    return round_constants

def print_hex(c, last, rust=False):
    c = int(c)
    if rust:
        print(f"        Fp::new({c}),")
    else:
        hex_length = (FIELD_SIZE + 3)//4 + 2 # +2 for "0x"
        print("{0:#0{1}x}".format(c, hex_length), end="" if last else ", ")

def calc_equivalent_constants(constants, MDS_matrix, t, R_F, R_P):
    constants_temp = [constants[index:index+t] for index in range(0, len(constants), t)]

    MDS_matrix_field_transpose = MDS_matrix.transpose()

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

    new_constants = [item for sublist in constants_temp for item in sublist]
    return new_constants

def print_round_constants(round_constants, n, t, field, optimized=False, rust=False):
    print("Number of round constants" + (" (optimized):" if optimized else ":"), len(round_constants))

    if field == 0:
        print("Round constants for GF(2^n):")
    elif field == 1:
        print("Round constants for GF(p):")

    assert len(round_constants) % t == 0
    rounds = len(round_constants) // t  # R_F + R_P
    for r in range(rounds):
        print("    [", end="\n" if rust else "")
        for (i, entry) in enumerate(round_constants[r*t : (r+1)*t]):
            print_hex(entry, i == t-1, rust=rust)
        print("    ]," if rust else "],")

def create_mds_p(n, t):
    M = matrix(F, t, t)

    # Sample random distinct indices and assign to xs and ys
    while True:
        flag = True
        rand_list = [F(grain_random_bits(n)) for _ in range(0, 2*t)]
        while len(rand_list) != len(set(rand_list)): # Check for duplicates
            rand_list = [F(grain_random_bits(n)) for _ in range(0, 2*t)]
        xs = rand_list[:t]
        ys = rand_list[t:]
        # xs = [F(ele) for ele in range(0, t)]
        # ys = [F(ele) for ele in range(t, 2*t)]
        for i in range(0, t):
            for j in range(0, t):
                if (flag == False) or ((xs[i] + ys[j]) == 0):
                    flag = False
                else:
                    entry = (xs[i] + ys[j])^(-1)
                    M[i, j] = entry
        if flag == False:
            continue
        return M
    
def calc_equivalent_matrices(MDS_matrix_field, t, R_P):
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

def generate_vectorspace(round_num, M, M_round, NUM_CELLS):
    t = NUM_CELLS
    s = 1
    V = VectorSpace(F, t)
    if round_num == 0:
        return V
    elif round_num == 1:
        return V.subspace(V.basis()[s:])
    else:
        mat_temp = matrix(F)
        for i in range(0, round_num-1):
            add_rows = []
            for j in range(0, s):
                add_rows.append(M_round[i].rows()[j][s:])
            mat_temp = matrix(mat_temp.rows() + add_rows)
        r_k = mat_temp.right_kernel()
        extended_basis_vectors = []
        for vec in r_k.basis():
            extended_basis_vectors.append(vector([0]*s + list(vec)))
        S = V.subspace(extended_basis_vectors)

        return S

def subspace_times_matrix(subspace, M, NUM_CELLS):
    t = NUM_CELLS
    V = VectorSpace(F, t)
    subspace_basis = subspace.basis()
    new_basis = []
    for vec in subspace_basis:
        new_basis.append(M * vec)
    new_subspace = V.subspace(new_basis)
    return new_subspace

# Returns True if the matrix is considered secure, False otherwise
def algorithm_1(M, NUM_CELLS):
    t = NUM_CELLS
    s = 1
    r = floor((t - s) / float(s))

    # Generate round matrices
    M_round = []
    for j in range(0, t+1):
        M_round.append(M^(j+1))

    for i in range(1, r+1):
        mat_test = M^i
        entry = mat_test[0, 0]
        mat_target = matrix.circulant(vector([entry] + ([F(0)] * (t-1))))

        if (mat_test - mat_target) == matrix.circulant(vector([F(0)] * (t))):
            return [False, 1]

        S = generate_vectorspace(i, M, M_round, t)
        V = VectorSpace(F, t)

        basis_vectors= []
        for eigenspace in mat_test.eigenspaces_right(format='galois'):
            if (eigenspace[0] not in F):
                continue
            vector_subspace = eigenspace[1]
            intersection = S.intersection(vector_subspace)
            basis_vectors += intersection.basis()
        IS = V.subspace(basis_vectors)

        if IS.dimension() >= 1 and IS != V:
            return [False, 2]
        for j in range(1, i+1):
            S_mat_mul = subspace_times_matrix(S, M^j, t)
            if S == S_mat_mul:
                print("S.basis():\n", S.basis())
                return [False, 3]

    return [True, 0]

# Returns True if the matrix is considered secure, False otherwise
def algorithm_2(M, NUM_CELLS):
    t = NUM_CELLS
    s = 1

    V = VectorSpace(F, t)
    trail = [None, None]
    test_next = False
    I = range(0, s)
    I_powerset = list(sage.misc.misc.powerset(I))[1:]
    for I_s in I_powerset:
        test_next = False
        new_basis = []
        for l in I_s:
            new_basis.append(V.basis()[l])
        IS = V.subspace(new_basis)
        for i in range(s, t):
            new_basis.append(V.basis()[i])
        full_iota_space = V.subspace(new_basis)
        for l in I_s:
            v = V.basis()[l]
            while True:
                delta = IS.dimension()
                v = M * v
                IS = V.subspace(IS.basis() + [v])
                if IS.dimension() == t or IS.intersection(full_iota_space) != IS:
                    test_next = True
                    break
                if IS.dimension() <= delta:
                    break
            if test_next == True:
                break
        if test_next == True:
            continue
        return [False, [IS, I_s]]

    return [True, None]

# Returns True if the matrix is considered secure, False otherwise
def algorithm_3(M, NUM_CELLS):
    t = NUM_CELLS
    s = 1

    V = VectorSpace(F, t)

    l = 4*t
    for r in range(2, l+1):
        next_r = False
        res_alg_2 = algorithm_2(M^r, t)
        if res_alg_2[0] == False:
            return [False, None]

        # if res_alg_2[1] == None:
        #     continue
        # IS = res_alg_2[1][0]
        # I_s = res_alg_2[1][1]
        # for j in range(1, r):
        #     IS = subspace_times_matrix(IS, M, t)
        #     I_j = []
        #     for i in range(0, s):
        #         new_basis = []
        #         for k in range(0, t):
        #             if k != i:
        #                 new_basis.append(V.basis()[k])
        #         iota_space = V.subspace(new_basis)
        #         if IS.intersection(iota_space) != iota_space:
        #             single_iota_space = V.subspace([V.basis()[i]])
        #             if IS.intersection(single_iota_space) == single_iota_space:
        #                 I_j.append(i)
        #             else:
        #                 next_r = True
        #                 break
        #     if next_r == True:
        #         break
        # if next_r == True:
        #     continue
        # return [False, [IS, I_j, r]]
    
    return [True, None]

def generate_matrix(FIELD, FIELD_SIZE, NUM_CELLS):
    if FIELD == 0:
        print("Matrix generation not implemented for GF(2^n).")
        exit(1)
    elif FIELD == 1:
        mds_matrix = create_mds_p(FIELD_SIZE, NUM_CELLS)
        result_1 = algorithm_1(mds_matrix, NUM_CELLS)
        result_2 = algorithm_2(mds_matrix, NUM_CELLS)
        result_3 = algorithm_3(mds_matrix, NUM_CELLS)
        while result_1[0] == False or result_2[0] == False or result_3[0] == False:
            mds_matrix = create_mds_p(FIELD_SIZE, NUM_CELLS)
            result_1 = algorithm_1(mds_matrix, NUM_CELLS)
            result_2 = algorithm_2(mds_matrix, NUM_CELLS)
            result_3 = algorithm_3(mds_matrix, NUM_CELLS)
        return mds_matrix

def invert_matrix(M):
    MS = MatrixSpace(F, NUM_CELLS, NUM_CELLS, sparse=False)
    return MS.matrix(M).inverse()

def print_matrix(M, t, rust=False):
    for row in range(t):
        print("    [", end="\n" if rust else "")
        for (i, entry) in enumerate(M[row]):
            print_hex(entry, i == t-1, rust=rust)
        print("    ]," if rust else "],")

def print_linear_layer(M, n, t, optimized=False, rust=False):
    print("n:", n)
    print("t:", t)
    print("N:", (n * t))
    print("Result Algorithm 1:\n", algorithm_1(M, NUM_CELLS))
    print("Result Algorithm 2:\n", algorithm_2(M, NUM_CELLS))
    print("Result Algorithm 3:\n", algorithm_3(M, NUM_CELLS))
    print("Prime number:", "0x" + hex(PRIME_NUMBER))

    print("MDS matrix" + (" (optimized):" if optimized else ":"))
    print_matrix(M, t, rust=rust)

    if not optimized:
        print("Inverse MDS matrix:")
        print_matrix(invert_matrix(M), t, rust=rust)

def main(args):
    if len(args) < 6:
        print("Usage: sage generate_parameters_grain.sage <field> <s_box> <field_size> <num_cells> <R_F> <R_P> (<prime_number_hex>) [--rust]")
        print("field = 1 for GF(p)")
        print("s_box = 0 for x^alpha, s_box = 1 for x^(-1)")
        return

    # Parameters
    global FIELD, SBOX, FIELD_SIZE, NUM_CELLS, R_F_FIXED, R_P_FIXED, PRIME_NUMBER, F

    FIELD = int(args[0]) # 0 .. GF(2^n), 1 .. GF(p)
    SBOX = int(args[1]) # 0 .. x^alpha, 1 .. x^(-1)
    FIELD_SIZE = int(args[2]) # n
    NUM_CELLS = int(args[3]) # t
    R_F_FIXED = int(args[4])
    R_P_FIXED = int(args[5])

    PRIME_NUMBER = 0
    if FIELD == 0:
        args = args[6:]
    elif FIELD == 1 and len(args) < 7:
        print("Please specify a prime number (in hex format)!")
        return
    elif FIELD == 1 and len(args) >= 7:
        PRIME_NUMBER = int(args[6], 16) # e.g. 0xa7, 0xFFFFFFFFFFFFFEFF, 0xa1a42c3efd6dbfe08daa6041b36322ef
        args = args[7:]

    F = GF(PRIME_NUMBER)

    rust = '--rust' in args

    # Init
    init_generator(FIELD, SBOX, FIELD_SIZE, NUM_CELLS, R_F_FIXED, R_P_FIXED)

    # Matrix
    linear_layer = generate_matrix(FIELD, FIELD_SIZE, NUM_CELLS)
    print_linear_layer(linear_layer, FIELD_SIZE, NUM_CELLS, optimized=False, rust=rust)

    # Matrix alternative
    [linear_layer, v_col, w_hat_col, m00] = calc_equivalent_matrices(linear_layer, NUM_CELLS, R_P_FIXED)
    print_linear_layer(linear_layer, FIELD_SIZE, NUM_CELLS, optimized=True, rust=rust)
    print("v_collection")
    print_matrix(v_col, NUM_CELLS, rust=rust)
    print("w_hat_collection")
    print_matrix(v_col, NUM_CELLS, rust=rust)
    print("M_00")
    print_hex(m00, last=True, rust=rust)

    # Round constants
    round_constants = generate_constants(FIELD, FIELD_SIZE, NUM_CELLS, R_F_FIXED, R_P_FIXED, PRIME_NUMBER)
    print_round_constants(round_constants, FIELD_SIZE, NUM_CELLS, FIELD, optimized=False, rust=rust)

    # Round constants alternative
    round_constants_optimized = calc_equivalent_constants(round_constants, linear_layer, NUM_CELLS, R_F_FIXED, R_P_FIXED)
    print_round_constants(round_constants_optimized, FIELD_SIZE, NUM_CELLS, FIELD, optimized=True, rust=rust)

    print(f"NUM ROUNDS: {len(round_constants) // NUM_CELLS}")

if __name__ == "__main__":
    main(sys.argv[1:])
