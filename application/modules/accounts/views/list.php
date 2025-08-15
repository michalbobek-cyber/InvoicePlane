<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Moje účty</h3>
  </div>
  <div class="panel-body">
    <?php if (empty($accounts)) : ?>
      <p>Nemáte žádné účty.</p>
    <?php else: ?>
      <table class="table table-hover">
        <thead><tr><th>Název účtu</th><th>Role</th><th>Akce</th></tr></thead>
        <tbody>
        <?php foreach ($accounts as $acc): ?>
          <tr>
            <td><?=htmlspecialchars($acc['account_name'])?></td>
            <td><?=htmlspecialchars($acc['role'])?></td>
            <td><a class="btn btn-primary btn-sm" href="<?=site_url('accounts/switch/'.$acc['account_id'])?>">Přepnout</a></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </div>
</div>
