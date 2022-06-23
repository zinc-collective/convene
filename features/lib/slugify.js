export default (function slugify(str) {
    return str.replace(/\s+/g, "-").toLowerCase();
});
