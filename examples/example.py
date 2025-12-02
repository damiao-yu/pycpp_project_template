from myproject import add_one


def main() -> None:
    value = 41
    print("add_one({}) = {}".format(value, add_one(value)))


if __name__ == "__main__":
    main()
