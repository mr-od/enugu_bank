package util

const (
	ENU = "ENU"
	AWK = "AWK"
	OWR = "OWR"
	UMU = "UMU"
	ABA = "ABA"
	NGN = "NGN"
	PHC = "PHC"
	CAL = "CAL"
	UYO = "UYO"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case ENU, AWK, OWR, UMU, ABA, NGN, PHC, CAL, UYO:
		return true
	}
	return false
}
