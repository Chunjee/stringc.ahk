class stringc {

	; --- Static Methods ---
	/**
	* Compares two strings using a custom comparison function, if provided, and returns a similarity score.
	*
	* This method calculates the similarity score between two input strings. If a custom comparison function is provided,
	* it applies this function to the input strings before performing the comparison. The similarity score is computed based
	* on the number of matching bigrams (pairs of characters) between the two strings. The score is rounded to two decimal places.
	*
	* @param {string} param_string1 - The first string to be compared.
	* @param {string} param_string2 - The second string to be compared.
	* @param {Function} [param_function=""] - An optional custom function to preprocess the strings before comparison.
	*                                          The function is called with two arguments: the first and second string.
	* @returns {number} - The similarity score between the two strings, ranging from 0 to 1. A score of 0 indicates no similarity,
	*                     and a score of 1 indicates identical strings. If the similarity score is less than 0.005, it returns 0.
	*/
	compare(param_string1, param_string2, param_function:="") {
		; prepare
		if (this._internal_isFunction(param_function)) {
			param_string1 := param_function.call(param_string1, param_string2)
			param_string2 := param_function.call(param_string2, param_string1)
		}

		; perform
		vCount := 0
		; make default key value 0 instead of a blank string
		l_arr := {base:{__Get:func("abs").bind(0)}}
		loop, % vCount1 := strLen(param_string1) - 1 {
			l_arr["z" subStr(param_string1, A_Index, 2)]++
		}
		loop, % vCount2 := strLen(param_string2) - 1 {
			if (l_arr["z" subStr(param_string2, A_Index, 2)] > 0) {
				l_arr["z" subStr(param_string2, A_Index, 2)]--
				vCount++
			}
		}
		vSDC := round((2 * vCount) / (vCount1 + vCount2), 2)
		; round to 0 if less than 0.005
		if (!vSDC || vSDC < 0.005) {
			return 0
		}
		; return 1 if rounded to 1.00
		if (vSDC = 1) {
			return 1
		}
		return vSDC
	}

	/**
	* Compares a string with each element in an array of strings, using a custom comparison function if provided,
	* and returns an object containing the best match and a sorted list of all comparisons.
	*
	* This method iterates over an array of strings, comparing each string to a given target string. If a custom
	* comparison function is provided, it preprocesses each string before performing the comparison. Each comparison
	* is scored using the `compare` method, and the results are stored in a new array. The array is then sorted by
	* the similarity scores, and the best match is identified.
	*
	* @param {Object} param_array - An array-like object where each element is a string to be compared with the target string.
	* @param {string} param_string - The target string to be compared against each element in the array.
	* @param {Function} [param_function=""] - An optional custom function to preprocess the strings before comparison.
	*                                          The function is called with four arguments: the string to process, a key, the array of strings, and the comparison string
	* @returns {Object} - An object containing two properties:
	*                     - `bestMatch`: An object representing the best match with the highest similarity score.
	*                     - `ratings`: An array of objects, each containing a `target` string and its `rating` score,
	*                                   sorted in descending order of similarity.
	* @throws {Error} - Throws an exception if `param_array` is not an object.
	*/
	compareAll(param_array, param_string, param_function:="") {
		if (!isObject(param_array)) {
			throw exception("Expected object", -1)
		}

		; Score each option and save into a new array
		l_arr := []
		for key, value in param_array {
			; functor
			if (this._internal_isFunction(param_function)) {
				value := param_function.call(value, key, param_array, param_string)
			}
			l_arr[A_Index, "rating"] := this.compare(param_string, value)
			l_arr[A_Index, "target"] := value
		}

		;sort the rated array
		l_sortedArray := this._internal_Sort2DArrayFast(l_arr, "rating")
		; create the besMatch property and final object
		l_object := {bestMatch: l_sortedArray[1].clone(), ratings: l_sortedArray}
		return l_object
	}

	/**
	* Finds the best match for a given string from an array of strings, using a custom comparison function if provided.
	*
	* This method iterates over an array of strings and compares each string to a target string. If a custom comparison
	* function is provided, it preprocesses each string before performing the comparison. The method identifies and returns
	* the string from the array that has the highest similarity score to the target string.
	*
	* @param {Object} param_array - An array-like object where each element is a string to be compared with the target string.
	* @param {string} param_string - The target string to be compared against each element in the array.
	* @param {Function} [param_function=""] - An optional custom function to preprocess the strings before comparison.
	*                                          The function is called with four arguments: the string to process, a key, the array of strings, and the comparison string
	* @returns {string} - The string from the array that has the highest similarity score to the target string.
	* @throws {Error} - Throws an exception if `param_array` is not an object.
	*/
	bestMatch(param_array, param_string, param_function:="") {
		if (!IsObject(param_array)) {
			throw exception("Expected object", -1)
		}
		l_highestRating := 0

		for key, value in param_array {
			; functor
			if (this._internal_isFunction(param_function)) {
				value := param_function.call(value, key, param_array, param_string)
			}
			l_rating := this.compare(param_string, value)
			if (l_highestRating < l_rating) {
				l_highestRating := l_rating
				l_bestMatchValue := value
			}
		}
		return l_bestMatchValue
	}

	; --- Intertal Methods ---
	_internal_isFunction(param) {
		funcRefrence := numGet(&(_ := Func("inStr").bind()), "ptr")
		return (isFunc(param) || (isObject(param) && (numGet(&param, "ptr") = funcRefrence)))
	}

	_internal_Sort2DArrayFast(param_arr, param_key)
	{
		for index, obj in param_arr {
			out .= obj[param_key] "+" index "|"
			; "+" allows for sort to work with just the value
			; out will look like:   value+index|value+index|
		}

		v := param_arr[param_arr.minIndex(), param_key]
		if v is number
			type := " N "
		; remove trailing |
		out := subStr(out, 1, strLen(out) -1)
		; sort and convert to array
		sort, out, % "D| " type  " R"
		l_arr := []
		loop, parse, out, |
		{
			l_arr.push(param_arr[subStr(A_LoopField, inStr(A_LoopField, "+") + 1)])
		}
		return l_arr
	}
}
