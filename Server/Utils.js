let Utils = {
	//sanitize user input before tocuing the db..
	sanitize: function sanitize(v) {
		if (v instanceof Object) {
			for (var key in v) {
				if (/^\$/.test(key)) {
					delete v[key];
				} else {
					sanitize(v[key]);
				}
			}
		}
		return v;
	},
	selectRandomFromArray: function selectRandomFromArray(arr) {
		const rnd = Math.floor(Math.random() * arr.length);
		return arr[rnd];
	},
	ValidateRegisterForm: function ValidateRegisterForm() {
		//validate same results an in the client
		statusMessage = '';
		const regexMailTest = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
		const isNotReallyLong =
			Object.values(formInput).findIndex((elm) => {
				return elm.length > 100;
			}) == -1;
		const isEmailValid = regexMailTest.test(formInput.mail);
		const isPasswordValid = IsStrongPassword(formInput.password) && formInput.password.length >= 8;
		return isNotReallyLong && isEmailValid && isPasswordValid;
	}
};
module.exports = Utils;
