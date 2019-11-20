class Dieter:
    def __init__(self):
        self.amount_taken = 0

    def take_some(self,q,prev):
        if self.amount_taken == 14:
            print('dieter took 0, cause he"s on a diet')
            return 0
        else:
            amount = min([14-self.amount_taken,q,7])
            self.amount_taken += amount
            print('dieter took',amount)
            return amount

class Spiller:
    def take_some(self,q,prev):
        spilled = round(q*.1)
        q -= spilled
        take = min(q,8)
        print('spiller spilled',spilled,'and took',take)
        return take + spilled

class Fatso:
    def take_some(self,q,prev):
        took = min(q,10)
        print('Fatso took',took)
        return took

class Copycat:
    def take_some(self,q,prev):
        took = min(q,prev)
        print('Copycat took',took)
        return took


def eat_popcorn(q,s):
    people = []
    for c in s:
        if c == 'g':
            people.append(Fatso())
        elif c == 'c':
            people.append(Copycat())
        elif c == 'd':
            people.append(Dieter())
        elif c == 's':
            people.append(Spiller())
        else:
            print('invalid char:',c)

    i = 0
    prev_eaten = 0
    amount_eaten = 0
    while q > 0:
        prev_eaten = people[i].take_some(q,prev_eaten)
        q -= prev_eaten
        amount_eaten += prev_eaten
        print('bucket has',q,'kernels left')

        i += 1
        if i >= len(s):
            if amount_eaten == 0:
                exit("infinite loop")
            i = 0
            amount_eaten = 0

    print('bucket is empty :(')


eat_popcorn(140,'ddd')
