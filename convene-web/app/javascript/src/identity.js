export default class Identity {
  set name(name) {
    sessionStorage.setItem("name", name);
    return true;
  }

  set pronoun(pronoun) {
    sessionStorage.setItem("pronoun", pronoun);
    return true;
  }

  get personInfo() {
    return {
      name: sessionStorage.getItem("name"),
      pronoun: sessionStorage.getItem("pronoun"),
    };
  }
}
