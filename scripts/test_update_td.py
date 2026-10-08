import unittest

from update_td import FORMULA, current_tag, render_formula, select_release, version_tuple


def release(tag, **kwargs):
    return {"tag_name": tag, "published_at": "2026-10-08T00:00:00Z", **kwargs}


class UpdateTdTests(unittest.TestCase):
    def test_no_release_and_unpublished_tags(self):
        self.assertIsNone(select_release([]))
        self.assertIsNone(select_release([release("v1.0.0", draft=True), release("v2.0.0", prerelease=True)]))
        with self.assertRaises(ValueError):
            select_release([], "v0.65.0")  # inherited Git tag is not a fork release

    def test_latest_stable_by_version_not_api_order(self):
        releases = [release("v1.9.0"), release("v1.10.0"), release("v9.0.0", prerelease=True), release("v2.0.0-rc.1")]
        self.assertEqual(select_release(releases), "v1.10.0")
        self.assertEqual(select_release(releases, "v1.9.0"), "v1.9.0")

    def test_version_rejects_invalid_and_injected_tags(self):
        for tag in ["v01.2.3", "1.2.3", "v1.2.3\n", 'v1.2.3"; echo bad', "v1.2.3/other"]:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                version_tuple(tag)

    def test_render_preserves_build_and_dependencies(self):
        formula = FORMULA.read_text()
        updated = render_formula(formula, "v1.2.3", "a" * 64)
        self.assertEqual(current_tag(updated), "v1.2.3")
        self.assertEqual(updated.count('  url "'), 1)
        self.assertIn('depends_on "gh"', updated)
        self.assertEqual(formula.split("  # td-release-end")[1], updated.split("  # td-release-end")[1])
        self.assertEqual(render_formula(updated, "v1.2.3", "a" * 64), updated)
        newer = render_formula(updated, "v1.2.4", "b" * 64)
        self.assertNotIn("v1.2.3", newer)
        self.assertIn('sha256 "' + "b" * 64 + '"', newer)

    def test_broken_formula_and_hash_fail_closed(self):
        with self.assertRaises(ValueError):
            render_formula("class Td < Formula\nend\n", "v1.2.3", "a" * 64)
        with self.assertRaises(ValueError):
            render_formula(FORMULA.read_text(), "v1.2.3", "not-a-sha")


if __name__ == "__main__":
    unittest.main()
