resource "aws_iam_group" "group" {
  for_each = var.teams

  name = each.key
  path = each.value.path
}

resource "aws_iam_group_membership" "membership" {
  for_each = var.teams

  name  = "${each.key}-membership"
  users = each.value.members
  group = aws_iam_group.group[each.key].name

  depends_on = [
    aws_iam_group.group
  ]
}

resource "aws_iam_group_policy" "group_policy" {
  for_each = var.teams

  name   = "${each.key}-policy"
  group  = aws_iam_group.group[each.key].name
  policy = each.value.policy

  depends_on = [
    aws_iam_group.group
  ]
}
