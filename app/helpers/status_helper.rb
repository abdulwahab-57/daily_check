module StatusHelper
  def status_badge(status)
    colors = {
      # For projects
      "draft" => "bg-gray-100 text-gray-800 ring-1 ring-gray-300",
      "active" => "bg-indigo-100 text-indigo-800 ring-1 ring-indigo-300",
      "archived" => "bg-amber-100 text-amber-800 ring-1 ring-amber-300",
      "completed" => "bg-emerald-100 text-emerald-800 ring-1 ring-emerald-300",
      # For todos
      "todo" => "bg-slate-100 text-slate-800 ring-1 ring-slate-300",
      "in_progress" => "bg-indigo-100 text-indigo-800 ring-1 ring-indigo-300",
      "blocked" => "bg-rose-100 text-rose-800 ring-1 ring-rose-300",
      "done" => "bg-emerald-100 text-emerald-800 ring-1 ring-emerald-300",
      "canceled" => "bg-zinc-100 text-zinc-800 ring-1 ring-zinc-300"
    }

    content_tag(:span, status.humanize,
      class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{colors[status]}")
  end
end
