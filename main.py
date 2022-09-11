bEval = eval
bPrint = print
input = input(">>> ")
if '[' in input or ']' in input:
    print('[ 당신은 탈옥하는데 실패했습니다 :( ]')
    exit(-1)
globals()['__builtins__'].__dict__.clear()
bPrint(bEval(input, {}, {}))
